import unittest
from unittest.mock import patch, MagicMock
from main import LoggerClient
from main import ExternalInputStore
from main import AWSSession
from main import AWSS3Facade


class TestLoggerClient(unittest.TestCase):
    def test_that_logger_throws_exception_when_instantiated(self):
        """
            Make sure that the LoggerClient class throws an error when instantiated.
        """
        with self.assertRaises(RuntimeError):
            LoggerClient()

    def test_that_only_one_logger_is_instantiated_during_execution(self):
        """
            Make sure that the LoggerClient class is a Singleton.
        """
        logger1 = LoggerClient.instance()
        logger2 = LoggerClient.instance()
        self.assertIs(logger1, logger2, "LoggerSetup should return the same logger instance")


class TestExternalInputStore(unittest.TestCase):

    @patch('main.os.getenv')
    def test_that_get_environment_variable_returns_value_when_key_exists(self, mock_getenv):
        """
            Make sure that the ExternalInputStore class retrieves the value of a given environment variable.
        """
        mock_getenv.return_value = "value"
        self.assertEqual(
            "value",
            ExternalInputStore.get_environment_variable("key"),
            "get_environment_variable should return the value of the key"
        )

    @patch('main.os.getenv')
    def test_that_get_environment_variable_raises_exception_when_key_does_not_exist(self, mock_getenv):
        """
            Make sure that the ExternalInputStore class throws an error when a desired environment variable is not set.
        """
        mock_getenv.return_value = None
        key = 'key'

        with self.assertRaises(ExternalInputStore.EnvironmentVariableNotSet) as context:
            ExternalInputStore.get_environment_variable(key)

        self.assertEqual(str(context.exception), f"Environment variable '{key}' is required")
        mock_getenv.assert_called_once_with(key)


class TestAwsSession(unittest.TestCase):
    @patch('main.boto3.Session')
    @patch('main.AWSSession.is_valid_service_name', new_callable=MagicMock)
    def test_that_succeeds_to_return_a_client(self, mock_is_valid_service_name, mock_session):
        session = MagicMock()
        mock_session.return_value = session
        aws_session = AWSSession("eu-west−1")
        mock_is_valid_service_name.return_value = True
        client = aws_session.get_client("s3")
        self.assertEqual(client, session.client.return_value, "get_client should return a valid operational client")

    def test_that_fails_to_return_client_when_service_name_is_invalid(self):
        aws_session = AWSSession("eu-west−1")
        with self.assertRaises(AWSSession.SessionInvalidServiceName):
            aws_session.get_client("service_name")

    def test_that_fails_when_region_name_is_empty(self):
        with self.assertRaises(AWSSession.SessionCreationError):
            AWSSession("")

    @patch('main.boto3.Session.get_available_services', new_callable=MagicMock)
    def test_that_fails_when_service_name_is_not_correct(self, mock_get_available_services):
        mock_get_available_services.return_value = ["s3", "ec2", "rds"]
        aws_session = AWSSession("eu-west−1")
        with self.assertRaises(AWSSession.SessionInvalidServiceName):
            aws_session.get_client("service_name")


if __name__ == '__main__':
    unittest.main()
