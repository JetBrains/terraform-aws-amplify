import os
import json
import logging
import boto3
from urllib.request import Request, urlopen
from botocore.exceptions import ClientError


class LoggerClient:
    __instance = None

    def __init__(self):
        raise RuntimeError('Call instance() instead')

    @classmethod
    def instance(cls):
        if cls.__instance is None:
            cls.__instance = cls.__new__(cls)
            cls.__instance.logger = logging.getLogger(__name__)
            cls.__instance.logger.setLevel(logging.INFO)
            console_handler = logging.StreamHandler()
            console_handler.setLevel(logging.INFO)
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            console_handler.setFormatter(formatter)
            cls.__instance.logger.addHandler(console_handler)
        return cls.__instance.logger


class ExternalInputStore:

    class EnvironmentVariableNotSet(Exception):
        def __init__(self, key):
            self.message = f"Environment variable '{key}' is required"
            super().__init__(self.message)

    def __init__(self):
        self.config = {
            "app_id": ExternalInputStore.get_environment_variable("AWS_AMPLIFY_APP_ID"),
            "s3_bucket_name": ExternalInputStore.get_environment_variable("AWS_S3_BUCKET_NAME"),
            "s3_key": ExternalInputStore.get_environment_variable("AWS_S3_KEY"),
            "branch_name": ExternalInputStore.get_environment_variable("AWS_AMPLIFY_DEPLOYMENT_BRANCH_NAME"),
            "region": ExternalInputStore.get_environment_variable("REGION")
        }

    @staticmethod
    def get_environment_variable(key):
        value = os.getenv(key)
        if value is None:
            raise ExternalInputStore.EnvironmentVariableNotSet(key)
        return value


class AWSSession:
    class SessionCreationError(Exception):
        def __init__(self):
            self.message = f"Failed to create a new AWS SDK session"
            super().__init__(self.message)

    class SessionInvalidServiceName(Exception):
        def __init__(self, service_name):
            self.message = f"Service name '{service_name}' is not a valid AWS service"
            super().__init__(self.message)

    def __init__(self, region):
        try:
            if region is None or region == "":
                raise AWSSession.SessionCreationError()
            self.session = boto3.Session(region_name=region)
        except TypeError:
            raise AWSSession.SessionCreationError()

    def is_valid_service_name(self, service_name):
        return service_name in boto3.Session().get_available_services()

    def get_client(self, service_name):
        if not self.is_valid_service_name(service_name):
            raise AWSSession.SessionInvalidServiceName(service_name)
        return self.session.client(service_name)


class AWSAmplifyManualDeploymentManager:
    __amplify_client = None
    __latest_deployment_object = None
    __app_id = None
    __branch_name = None

    def __init__(self, session, app_id, branch_name):
        self.__amplify_client = session.get_client('amplify')
        self.__app_id = app_id
        self.__branch_name = branch_name
        self.__create_deployment()

    def __create_deployment(self):
        response = self.__amplify_client.create_deployment(appId=self.__app_id, branchName=self.__branch_name)

        deployment_spec = {
            "jobId": response['jobId'],
            "zipUploadUrl": response['zipUploadUrl']
        }

        self.__latest_deployment_object = deployment_spec
        LoggerClient.instance().info(f"JobId: {self.__latest_deployment_object['jobId']}, zipUploadUrl: {self.__latest_deployment_object['zipUploadUrl']}")

    def __start_deployment(self):
        response = self.__amplify_client.start_deployment(
            appId=self.__app_id,
            branchName=self.__branch_name,
            jobId=self.__latest_deployment_object['jobId']
        )
        LoggerClient.instance().info(f"Deployment started: {response}")

    def __upload_zip_archive(self, file_path="/tmp/archive.zip"):
        with open(file_path, 'rb') as file:
            req = Request(self.get_deployment_upload_url(), data=file.read(), method='PUT', headers={'Content-Type': 'application/zip'})
            with urlopen(req) as response:
                LoggerClient.instance().info("File uploaded successfully, Status code: %s", response.status)

    def get_deployment_job_id(self):
        return self.__latest_deployment_object["jobId"]

    def get_deployment_upload_url(self):
        return self.__latest_deployment_object["zipUploadUrl"]

    def deploy_static_website(self, file_path="/tmp/archive.zip"):
        self.__upload_zip_archive(file_path)
        self.__start_deployment()


class AWSS3Facade:
    class S3NoArtifactExists(Exception):
        def __init__(self, bucket, key):
            self.message = f"Artifact '{key}' does not exist in the specified S3 bucket '{bucket}'"
            super().__init__(self.message)

    __s3_client = None

    def __init__(self, session):
        self.__s3_client = session.get_client('s3')

    def artifact_exists(self, bucket, key):
        try:
            self.__s3_client.head_object(Bucket=bucket, Key=key)
            return True
        except ClientError:
            return False

    def download_artifact(self, bucket, key, local_path="/tmp/archive.zip"):
        if self.artifact_exists(bucket, key):
            with open(local_path, 'wb') as file:
                self.__s3_client.download_fileobj(bucket, key, file)
            LoggerClient.instance().info(f"Successfully downloaded '{key}' to '{local_path}'")
        else:
            raise AWSS3Facade.S3NoArtifactExists(bucket, key)


def deployment(file_path="/tmp/archive.zip"):
    try:
        env_store = ExternalInputStore()
        local_file = file_path

        aws_session = AWSSession(env_store.config["region"])

        s3 = AWSS3Facade(aws_session)

        s3.download_artifact(
            env_store.config["s3_bucket_name"],
            env_store.config["s3_key"], local_file
        )

        amplify = AWSAmplifyManualDeploymentManager(
            aws_session,
            env_store.config["app_id"],
            env_store.config["branch_name"]
        )

        amplify.deploy_static_website(local_file)

        return {"statusCode": 200, "body": json.dumps("Deployment successful")}
    except ClientError as e:
        LoggerClient.instance().error(f"An error occurred: {e}")
        return {"statusCode": 500, "body": json.dumps(str(e))}


def lambda_handler(event, context):
    file = "/tmp/archive.zip"
    return deployment(file)
