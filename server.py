from flask import Flask, request, jsonify  # Added jsonify to the import
from flask_restful import Resource, Api
from api.hello_world import HelloWorld
from flask_cors import CORS
from api.management import *
import db.swen610_db_utils as db_utils 

app = Flask(__name__)

api = Api(app)
CORS(app)

api.add_resource(Init, '/manage/init')  # Management API for initializing the DB
api.add_resource(Version, '/manage/version')  # Management API for checking DB version
api.add_resource(HelloWorld, '/') 
# api.add_resource()

@app.route('/users', methods=['GET'])
def get_users():
    db_utils.connect()
    query_string = "SELECT * FROM users"
    result = db_utils.exec_get_all(query_string)
    return {'users': result}

@app.route('/channels-communities', methods=['GET'])
def get_channels_communities():
    db_utils.connect()
    query_string1 = "SELECT * FROM channels"
    result1 = db_utils.exec_get_all(query_string1)
    query_string2 = "SELECT * FROM communities"
    result2 = db_utils.exec_get_all(query_string2)
    return {'channels': result1, 'communities': result2}

@app.route('/search', methods=['GET'])
def search():
    try:
        # Connect to the database
        db_utils.connect()

        # Get query parameters from the request
        search_string = request.args.get('query')  # Search for a string in message_text
        min_length = request.args.get('min_length', type=int)  # Minimum message length
        max_length = request.args.get('max_length', type=int)  # Maximum message length
        start_date = request.args.get('start_date')  # Start of the date range (format: YYYY-MM-DD)
        end_date = request.args.get('end_date')  # End of the date range (format: YYYY-MM-DD)

        # Base query (1=1 allows adding conditions dynamically)
        query_string = "SELECT * FROM Messages WHERE 1=1"
        parameters = []

        # Dynamically add conditions based on input parameters
        if search_string:
            query_string += " AND message_text ILIKE %s"  # Use ILIKE for case-insensitive search
            parameters.append(f'%{search_string}%')
        if min_length is not None:
            query_string += " AND LENGTH(message_text) >= %s"
            parameters.append(min_length)
        if max_length is not None:
            query_string += " AND LENGTH(message_text) <= %s"
            parameters.append(max_length)
        if start_date:
            query_string += " AND sent_date >= %s"
            parameters.append(start_date)
        if end_date:
            query_string += " AND sent_date <= %s"
            parameters.append(end_date)

        # Execute the query with parameters
        result = db_utils.exec_get_all(query_string, parameters)

        # If no results found, return a 404 response
        if not result:
            return jsonify({'message': 'No messages found'}), 404

        # Return the search results as JSON
        return jsonify({'messages': result})

    except Exception as e:
        # In case of any exception, return a 500 error and the exception message
        return jsonify({'error': str(e)}), 500

@app.route('/channel/<channel_id>/messages', methods=['GET'])
def get_messages_in_channel(channel_id):
    try:
        # Connect to the database
        db_utils.connect()
        # Query to fetch messages for the specified channel
        query_string = """
            select distinct m.message_text from Channels as ch
            join messages as m
            on m.channel_id = ch.id
            where m.channel_id = %s;
        """
        # Execute the query
        result = db_utils.exec_get_all(query_string, (channel_id,))
        # If no messages found for the channel, return 404
        if not result:
            return jsonify({'message': 'No messages found in this channel'}), 404

        # Return the result as a JSON response
        return jsonify({'messages': result}), 200
    
    except Exception as e:
        # Handle any errors that occur during the database query
        return jsonify({'error': str(e)}), 500
        
if __name__ == '__main__':
    rebuild_tables()
    app.run(debug=True)

