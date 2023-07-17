#importing necessary libraries
from flask import Flask, request, render_template, jsonify
import pyodbc
import json
import logging

#section to create the flask app and define the sql server interface
app = Flask(__name__)
# Create a connection to the database
server = 'localhost\\SQLEXPRESS'
database = 'timesheet2'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')
cursor = cnxn.cursor()
logging.basicConfig(filename='app.log', level=logging.DEBUG)

#base API error handler
@app.errorhandler(404)
def handle_not_found_error(error):
    return jsonify({'error': 'Not found'}), 404

# Define error handling for other types of errors
@app.errorhandler(Exception)
def handle_other_error(error):
    app.logger.error(error)
    return jsonify({'error': 'An error occurred'}), 500

#GET API routes for the application

@app.route('/users', methods=['GET'])
def get_users():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all users
        cursor.execute('SELECT UserID, UserName FROM Users')

        # Fetch all rows and convert them to a list of dictionaries
        users = cursor.fetchall()
        json_data = []
        for result in users:
            full_name = result[1]  # Assuming UserName stores the full name directly
            json_data.append({'UserID': result[0], 'Username': full_name})

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of users as a JSON response
        return jsonify(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500

#Define an index page that shows the entire database
@app.route('/users/all_info', methods=['GET'])
def get_users_all():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all users with their roles, companies, and projects
        cursor.execute("""
            SELECT u.UserID, u.UserName AS FullName,
            c.CompanyName AS 'Company Name', p.ProjectName, r.RoleName
            FROM Users u
            JOIN Companies c ON u.CompanyID = c.CompanyID
            JOIN UserProjectRoles upr ON u.UserID = upr.UserID
            JOIN Projects p ON upr.ProjectID = p.ProjectID
            JOIN Roles r ON upr.RoleID = r.RoleID;
        """)

        # Get the column names to use as keys in the JSON output
        row_headers = [x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        users = cursor.fetchall()
        json_data = []
        for result in users:
            # Create a new dictionary with the modified FullName field
            new_dict = {}
            for i in range(len(row_headers)):
                new_dict[row_headers[i]] = result[i]
            json_data.append(new_dict)

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of users as a JSON response
        return jsonify(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500


# Define a GET route to retreive all the companies in the database
@app.route('/companies', methods=['GET'])
def get_companies():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all companies
        cursor.execute('SELECT * FROM companies')

        # Get the column names to use as keys in the JSON output
        row_headers=[x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        companies = cursor.fetchall()
        json_data=[]
        for result in companies:
            json_data.append(dict(zip(row_headers,result)))

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of companies as a JSON response
        return json.dumps(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500


# Define a GET route to retrieve all roles
@app.route('/roles', methods=['GET'])
def get_roles():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all roles
        cursor.execute('SELECT * FROM roles')

        # Get the column names to use as keys in the JSON output
        row_headers=[x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        roles = cursor.fetchall()
        json_data=[]
        for result in roles:
            json_data.append(dict(zip(row_headers,result)))

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of roles as a JSON response
        return json.dumps(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500


# Define a GET route to retrieve all projects
@app.route('/projects', methods=['GET'])
def get_projects():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all projects
        cursor.execute('SELECT * FROM projects')

        # Get the column names to use as keys in the JSON output
        row_headers=[x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        projects = cursor.fetchall()
        json_data=[]
        for result in projects:
            json_data.append(dict(zip(row_headers,result)))

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of projects as a JSON response
        return json.dumps(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500


@app.route('/userprojects/<username>', methods=['GET'])
def get_user_projects(username):
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to retrieve the projects linked to the provided username
        query = """
        SELECT p.ProjectName
        FROM Users u
        JOIN UserProjectLink up ON u.UserID = up.UserID
        JOIN Projects p ON up.ProjectID = p.ProjectID
        WHERE (u.UserName) = ?
        """
        cursor.execute(query, (username,))

        # Fetch all rows and convert them to a list
        projects = [row[0] for row in cursor.fetchall()]

        # Close the cursor to free up resources
        cursor.close()

        # Return the projects as a JSON response
        return jsonify({'projects': projects})

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500


# Get all users assigned to a specific project
@app.route('/users/<project_name>', methods=['GET'])
def get_users_by_project(project_name):
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all users associated with the project
        cursor.execute('SELECT Users.* FROM Users INNER JOIN UserProjects ON Users.UserID = UserProjectLink.UserID INNER JOIN Projects ON UserProjectLink.ProjectID = Projects.ProjectID WHERE Projects.ProjectName = ?', project_name)

        # Get the column names to use as keys in the JSON output
        row_headers=[x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        users = cursor.fetchall()
        json_data=[]
        for result in users:
            json_data.append(dict(zip(row_headers,result)))

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of users associated with the project as a JSON response
        return json.dumps(json_data)

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500
    

@app.route('/timesheets', methods=['GET'])
def get_timesheets():
    user_name = request.args.get('UserName')
    project_name = request.args.get('ProjectName')

    try:
        # Establish a connection to the database
        cursor = cnxn.cursor()

        # Execute the SQL query with parameterized values
        query = f"""
        SELECT te.UserID, u.UserName, te.ProjectName, pm.ManagerName, te.WeekNumber,
               te.WeekStartDate, te.WeekEndDate,
               te.MondayHours, te.TuesdayHours, te.WednesdayHours, te.ThursdayHours, te.FridayHours
        FROM TimesheetEntries te
        JOIN Users u ON te.UserID = u.UserID
        JOIN ProjectManagers pm ON te.ManagerID = pm.ManagerID
        WHERE u.UserName = '{user_name}'
        AND te.ProjectName = '{project_name}'
        """

        cursor.execute(query)

        # Fetch all rows from the cursor
        entries = cursor.fetchall()

        # Prepare the response as a list of dictionaries
        response = []
        for row in entries:
            entry = {
                'UserID': row[0],
                'UserName': row[1],
                'ProjectName': row[2],
                'ManagerName': row[3],
                'WeekNumber': row[4],
                'WeekStartDate': row[5].isoformat(),
                'WeekEndDate': row[6].isoformat(),
                'MondayHours': row[7],
                'TuesdayHours': row[8],
                'WednesdayHours': row[9],
                'ThursdayHours': row[10],
                'FridayHours': row[11]
            }
            response.append(entry)

        # Return the response as JSON
        return jsonify(response)

    except Exception as e:
        # Add appropriate exception handling, logging, and error handling here
        print(f"An error occurred: {str(e)}")
        return jsonify({'error': 'An error occurred'}), 500
