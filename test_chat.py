import unittest 
from datetime import datetime

from tests.test_utils import *
class TestChat(unittest.TestCase):


    def test_list_all_users(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        count = get_rest_call(self, 'http://localhost:5000/users')
        self.assertEqual(len(count), 1)

    def test_list_communities_and_channels(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        data = get_rest_call(self, 'http://localhost:5000/channels-communities')
        expected_community_count = 2  
        self.assertEqual(len(data['communities']), expected_community_count)
        expected_channel_count = 4  
        self.assertEqual(len(data['channels']), expected_channel_count)


    def test_search_messages_by_string(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        params = {'query': "Hello"}
        data = get_rest_call(self, 'http://localhost:5000/search', params=params, expected_code=200)
        messages = data['messages']
        for message in messages:
            message_text = message[1]
        self.assertIn(params['query'], message_text)

            
    def test_search_messages_by_string_and_date(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        search_string = "Message from Larry"
        start_date = "1920-01-01"
        end_date = "1996-01-01"
        params = {
            'query': search_string,
            'start_date': start_date,
            'end_date': end_date
        }
        data = get_rest_call(self, 'http://localhost:5000/search', params=params, expected_code=200)
        messages = data['messages']
        for message in messages:
            message_text = message[1]
            parsed_date = datetime.strptime(message[2], '%a, %d %b %Y %H:%M:%S %Z')
            formatted_date = parsed_date.strftime('%Y-%m-%d')
            self.assertIn(search_string, message_text)
            self.assertTrue(start_date <= formatted_date <= end_date)

    def test_list_messages_in_nonexistent_channel(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        non_existent_channel_id = 99  # An ID that doesn't exist
        data = get_rest_call(self, f'http://localhost:5000/channel/{non_existent_channel_id}/messages', expected_code=404)
        self.assertEqual(data['message'], 'No messages found in this channel')


    def test_list_all_messages_in_channel(self):
        post_rest_call(self, 'http://localhost:5000/manage/init', expected_code=200)
        channel_id = 2
        expected_message_count = 4
        data = get_rest_call(self,f'http://localhost:5000/channel/{channel_id}/messages', expected_code=200)
        self.assertEqual(len(data['messages']), expected_message_count)
















