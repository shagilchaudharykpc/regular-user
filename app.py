from flask import Flask, request, render_template, jsonify
import pyodbc
import json
import logging

app = Flask(__name__)
# Create a connection to the database
server = 'localhost\\SQLEXPRESS'
database = 'timesheet2'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')
cursor = cnxn.cursor()
logging.basicConfig(filename='app.log', level=logging.DEBUG)

#API Routes handling the errors in the application

# Define error handling for database connection errors
@app.errorhandler(pyodbc.Error)
def handle_database_error(error):
    app.logger.error(error)
    return jsonify({'error': 'Database connection error'}), 500

# Define error handling for 404 errors
@app.errorhandler(404)
def handle_not_found_error(error):
    return jsonify({'error': 'Not found'}), 404

# Define error handling for other types of errors
@app.errorhandler(Exception)
def handle_other_error(error):
    app.logger.error(error)
    return jsonify({'error': 'An error occurred'}), 500

#GET API Routes for the application

@app.route('/users', methods=['GET'])
def get_users():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all users
        cursor.execute('SELECT UserID, FirstName, LastName FROM Users')

        # Fetch all rows and convert them to a list of dictionaries
        users = cursor.fetchall()
        json_data=[]
        for result in users:
            full_name = result[1] + " " + result[2] # concatenate FirstName and LastName with a space in between
            json_data.append({'UserID': result[0], 'Username': full_name}) # store the full name and UserID in a new dictionary key

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
            SELECT u.UserID, CONCAT(u.FirstName, ' ', u.LastName) AS FullName,
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
                if row_headers[i] == 'Username':
                    new_dict['Username'] = result[i]
                else:
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

"""
# Define a GET route to retrieve all user projects
@app.route('/userprojects', methods=['GET'])
def get_user_projects():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to get all rows from the UserProjects table
        cursor.execute('SELECT * FROM UserProjects')

        # Get the column names to use as keys in the JSON output
        row_headers=[x[0] for x in cursor.description]

        # Fetch all rows and convert them to a list of dictionaries
        user_projects = cursor.fetchall()
        json_data=[]
        for result in user_projects:
            json_data.append(dict(zip(row_headers,result)))

        # Close the cursor to free up resources
        cursor.close()

        # Return the list of user projects as a JSON response
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
"""

@app.route('/userprojects/<username>', methods=['GET'])
def get_user_projects(username):
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to retrieve the projects linked to the provided username
        query = """
        SELECT p.ProjectName
        FROM Users u
        JOIN UserProjects up ON u.UserID = up.UserID
        JOIN Projects p ON up.ProjectID = p.ProjectID
        WHERE (u.FirstName + ' ' + u.LastName) = ?
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
        cursor.execute('SELECT Users.* FROM Users INNER JOIN UserProjects ON Users.UserID = UserProjects.UserID INNER JOIN Projects ON UserProjects.ProjectID = Projects.ProjectID WHERE Projects.ProjectName = ?', project_name)

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
    
"""
@app.route('/timesheet', methods=['GET'])
def get_timesheet_entries():
    try:
        username = request.args.get('username')
        project = request.args.get('project')

        # Assuming you have a SQL query to fetch timesheet entries based on username and project
        query = "SELECT * FROM timesheets WHERE username = %s AND project = %s"
        cursor.execute(query, (username, project))

        # Assuming you have a function to fetch all rows from the cursor
        entries = cursor.fetchall()

        # Assuming you have a function to convert the entries to a JSON format
        entries_json = convert_to_json(entries)

        return jsonify(entries_json)

    except Exception as e:
        # Log the exception
        logging.error(f"Error occurred while retrieving timesheet entries: {e}")

        # Return an error message as JSON response
        return jsonify({'error': 'An error occurred while retrieving timesheet entries'}), 500
"""

@app.route('/timesheets', methods=['GET'])
def get_timesheets():
    first_name = request.args.get('FirstName')
    project_name = request.args.get('ProjectName')

    try:
        # Establish a connection to the database
        cursor = cnxn.cursor()

        # Execute the SQL query with parameterized values
        query = f"""
        SELECT te.UserID, u.FirstName, te.ProjectName, pm.ManagerName, te.WeekNumber,
               te.WeekStartDate, te.WeekEndDate,
               te.MondayHours, te.TuesdayHours, te.WednesdayHours, te.ThursdayHours, te.FridayHours
        FROM TimesheetEntries te
        JOIN Users u ON te.UserID = u.UserID
        JOIN ProjectManagers pm ON te.ManagerID = pm.ManagerID
        WHERE u.FirstName = '{first_name}'
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
                'FirstName': row[1],
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





#POST API Route for the application

# Define a POST route to add a new user
@app.route('/users', methods=['POST'])
def add_user():
    try:
        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Get request data
        data = request.json
        if not data:
            return jsonify({'message': 'No input data provided.'}), 400
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        role_name = data.get('role_name')
        project_name = data.get('project_name')
        company_name = data.get('company_name')

        # Validate input
        if not all([first_name, last_name, role_name, project_name, company_name]):
            return jsonify({'message': 'Missing required input data.'}), 400

        # Get role ID
        cursor.execute("SELECT RoleID FROM Roles WHERE RoleName=?", role_name)
        role_id = cursor.fetchone()
        if not role_id:
            return jsonify({'message': f'Role "{role_name}" not found.'}), 404
        role_id = role_id[0]

        # Get project ID
        cursor.execute("SELECT ProjectID FROM Projects WHERE ProjectName=? AND CompanyID=(SELECT CompanyID FROM Companies WHERE CompanyName=?)", project_name, company_name)
        project_id = cursor.fetchone()
        if not project_id:
            return jsonify({'message': f'Project "{project_name}" not found in company "{company_name}".'}), 404
        project_id = project_id[0]

        # Get company ID
        cursor.execute("SELECT CompanyID FROM Companies WHERE CompanyName=?", company_name)
        company_id = cursor.fetchone()
        if not company_id:
            return jsonify({'message': f'Company "{company_name}" not found.'}), 404
        company_id = company_id[0]

        # Check if user already exists
        cursor.execute("SELECT UserID FROM Users WHERE FirstName=? AND LastName=? AND CompanyID=?", first_name, last_name, company_id)
        existing_user = cursor.fetchone()
        if existing_user:
            return jsonify({'message': 'User already exists.'}), 409

        # Add user to database
        cursor.execute("INSERT INTO Users (FirstName, LastName, CompanyID) VALUES (?, ?, ?)", first_name, last_name, company_id)
        cnxn.commit()

        # Get the newly inserted user's ID
        cursor.execute("SELECT @@IDENTITY")
        user_id = cursor.fetchone()[0]

        # Add user to UserProjectRoles table
        cursor.execute("INSERT INTO UserProjectRoles (UserID, RoleID, ProjectID) VALUES (?, ?, ?)", user_id, role_id, project_id)
        cnxn.commit()

        # Add user to UserProjects table
        cursor.execute("INSERT INTO UserProjects (UserID, ProjectID, RoleID) VALUES (?, ?, ?)", user_id, project_id, role_id)
        cnxn.commit()

        # Return success message
        return jsonify({'message': 'User added successfully.'}), 201

    except pyodbc.Error as e:
        logging.error(str(e))
        return jsonify({'message': 'An error occurred while processing your request.'}), 500

    except Exception as e:
        logging.error(str(e))
        return jsonify({'message': 'An error occurred while processing your request.'}), 500

@app.route('/companies', methods=['POST'])
def add_company():
    try:
        company_name = request.json.get('company_name')

        if 'company_name' not in request.json:
            return jsonify({'error': 'Company name is required'}), 400

        cursor = cnxn.cursor()
        cursor.execute('SELECT COUNT(*) FROM Companies WHERE CompanyName = ?', company_name)
        count = cursor.fetchone()[0]

        if count > 0:
            return jsonify({'error': f'Company with name {company_name} already exists'}), 409

        cursor.execute('INSERT INTO Companies (CompanyName) VALUES (?)', company_name)
        cnxn.commit()

        return jsonify({'message': f'Company {company_name} added successfully'}), 201
    except Exception as e:
        logging.error(str(e))
        return jsonify({'error': 'An error occurred while processing your request'}), 500

        
# Define a POST route to add a new project to the database
@app.route('/projects', methods=['POST'])
def add_project():
    try:
        # Get the project data from the request body
        project_name = request.json['project_name']
        company_name = request.json['company_name']

        # Create a cursor object to execute SQL queries
        cursor = cnxn.cursor()

        # Execute the SQL query to check if the company exists
        cursor.execute('SELECT COUNT(*) FROM Companies WHERE CompanyName = ?', company_name)
        company_count = cursor.fetchone()[0]

        if company_count == 0:
            # If the company does not exist, return an error message
            return jsonify({'error': f'Company {company_name} does not exist'}), 404

        # Execute the SQL query to check if the project exists
        cursor.execute('SELECT COUNT(*) FROM Projects WHERE ProjectName = ? AND CompanyID = (SELECT CompanyID FROM Companies WHERE CompanyName = ?)', (project_name, company_name))
        project_count = cursor.fetchone()[0]

        if project_count > 0:
            # If the project already exists, return an error message
            return jsonify({'error': f'Project {project_name} already exists for company {company_name}'}), 409

        # Execute the SQL query to insert a new project into the projects table
        cursor.execute('INSERT INTO Projects (ProjectName, CompanyID) VALUES (?, (SELECT CompanyID FROM Companies WHERE CompanyName = ?))', (project_name, company_name))

        # Commit the transaction to save the changes to the database
        cnxn.commit()

        # Return a success message and a 201 status code
        return jsonify({'message': 'Project added successfully'}), 201

    # Handle specific exceptions that may be raised during the execution of the code
    except pyodbc.Error as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Database query error: {error}')
        # Rollback the transaction to undo any changes made to the database
        cnxn.rollback()
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Database query error'}), 500
    except Exception as error:
        # Log the error message using Flask's built-in logger
        app.logger.error(f'Unknown error: {error}')
        # Rollback the transaction to undo any changes made to the database
        cnxn.rollback()
        # Return a JSON response with an error message and a 500 status code
        return jsonify({'error': 'Unknown error'}), 500

#PUT API routes for the application

# Define a PUT route to update a companies
@app.route('/companies', methods=['PUT'])
def update_company_name():
    try:
        # Get the new name and old name from the request body
        new_name = request.json['new_name']
        old_name = request.json['old_name']

        # Execute SQL update statement
        cursor = cnxn.cursor()
        cursor.execute('UPDATE Companies SET CompanyName = ? WHERE CompanyName = ?', new_name, old_name)
        cnxn.commit()

        # Return success message
        return jsonify({'message': 'Company name updated successfully'}), 200

    except KeyError:
        # If 'new_name' or 'old_name' keys are not found in request body
        return jsonify({'error': 'Missing required parameter: new_name or old_name'}), 400

    except pyodbc.Error as e:
        # Log the error
        app.logger.error(str(e))

        # Roll back any changes made to the database
        cnxn.rollback()

        # Return error message
        return jsonify({'error': 'Unable to update company name'}), 500

# Define a PUT route to update a user
@app.route('/users', methods=['PUT'])
def update_user_name():
    try:
        # Get the new first and last names, and old first and last names from the request body
        new_first_name = request.json['new_first_name']
        new_last_name = request.json['new_last_name']
        old_first_name = request.json['old_first_name']
        old_last_name = request.json['old_last_name']

        # Execute SQL update statement
        cursor = cnxn.cursor()
        cursor.execute('UPDATE Users SET FirstName = ?, LastName = ? WHERE FirstName = ? AND LastName = ?',
                       new_first_name, new_last_name, old_first_name, old_last_name)
        cnxn.commit()

        # Return success message
        return jsonify({'message': 'User name updated successfully'}), 200

    except KeyError:
        # If 'new_first_name', 'new_last_name', 'old_first_name', or 'old_last_name' keys are not found in request body
        return jsonify({'error': 'Missing required parameter: new_first_name, new_last_name, old_first_name, or old_last_name'}), 400

    except pyodbc.Error as e:
        # Log the error
        app.logger.error(str(e))

        # Roll back any changes made to the database
        cnxn.rollback()

        # Return error message
        return jsonify({'error': 'Unable to update user name'}), 500

# Define a PUT route to update a project
@app.route('/projects/update_projects', methods=['PUT'])
def update_project():
    try:
        # Get the new name and old name from the request body
        new_name = request.json['new_name']
        old_name = request.json['old_name']

        # Execute SQL update statement
        cursor = cnxn.cursor()
        cursor.execute('UPDATE Projects SET ProjectName = ? WHERE ProjectName = ?', new_name, old_name)
        cnxn.commit()

        # Return success message
        return jsonify({'message': 'Project updated successfully'}), 200

    except KeyError:
        # If 'new_name' or 'old_name' keys are not found in request body
        return jsonify({'error': 'Missing required parameter: new_name or old_name'}), 400

    except pyodbc.Error as e:
        # Log the error
        app.logger.error(str(e))

        # Roll back any changes made to the database
        cnxn.rollback()

        # Return error message
        return jsonify({'error': 'Unable to update project'}), 500

# Define a PUT route to update a user's role
@app.route('/users/update_role', methods=['PUT'])
def update_user_role():
    try:
        data = request.json
        first_name = data['first_name']
        last_name = data['last_name']
        role_name = data['role_name']
        project_name = data['project_name']
        company_name = data['company_name']

        # Get the role ID
        cursor.execute("SELECT RoleID FROM Roles WHERE RoleName=?", role_name)
        role_id = cursor.fetchone()
        if not role_id:
            return jsonify({'message': f'Role "{role_name}" not found.'}), 404
        role_id = role_id[0]

        # Get the project ID and company ID
        cursor.execute("""
            SELECT Projects.ProjectID, Companies.CompanyID 
            FROM Projects 
            JOIN Companies ON Projects.CompanyID = Companies.CompanyID 
            WHERE Projects.ProjectName = ? AND Companies.CompanyName = ?
        """, (project_name, company_name))
        project_company = cursor.fetchone()
        if not project_company:
            return jsonify({'message': f'Project "{project_name}" not found in company "{company_name}".'}), 404
        project_id, company_id = project_company

        # Update the user's role for the specified project and company
        cursor.execute("""
            UPDATE UserProjects 
            SET RoleID = ? 
            FROM Users 
            JOIN UserProjects ON Users.UserID = UserProjects.UserID 
            JOIN Projects ON UserProjects.ProjectID = Projects.ProjectID 
            JOIN Companies ON Projects.CompanyID = Companies.CompanyID 
            WHERE Users.FirstName = ? AND Users.LastName = ? 
            AND Projects.ProjectID = ? AND Companies.CompanyID = ?
        """, (role_id, first_name, last_name, project_id, company_id))

        cnxn.commit()
        app.logger.info(f"User role updated successfully: {first_name} {last_name}")
        return jsonify({'message': 'User role updated successfully'}), 200
    except KeyError as e:
        app.logger.error(f"KeyError: {str(e)}")
        return jsonify({'error': 'Missing or invalid input parameters'}), 400
    except pyodbc.Error as e:
        app.logger.error(f"Database error: {str(e)}")
        cnxn.rollback()
        return jsonify({'error': 'Failed to update user role'}), 500
    except Exception as e:
        app.logger.error(f"Unhandled exception: {str(e)}")
        cnxn.rollback()
        return jsonify({'error': 'Failed to update user role'}), 500
    
#API route that takes care of the authentication aided by the sql server
@app.route('/authenticate', methods=['POST'])
def authenticate():
    try:
        username = request.json['username']
        passcode = request.json['passcode']

        cursor = cnxn.cursor()
        cursor.execute("SELECT PassCode FROM UserCredentials WHERE UserName=?", username)
        result = cursor.fetchone()

        if result and result[0] == passcode:
            app.logger.info(f'User {username} authenticated successfully')
            return 'Authenticated'
        else:
            app.logger.warning(f'Failed authentication for user {username}')
            return 'Authentication failed', 401

    except Exception as e:
        app.logger.error(f'Error during authentication: {e}')
        return 'Error during authentication', 500

@app.route('/timesheets', methods=['POST'])
def create_timesheet():
    try:
        # Parse the JSON data from the request
        data = request.json

        # Extract the required fields from the JSON data
        first_name = data['FirstName']
        project_name = data['ProjectName']
        week_number = data['WeekNumber']
        week_start_date = data['WeekStartDate']
        week_end_date = data['WeekEndDate']
        monday_hours = data['MondayHours']
        tuesday_hours = data['TuesdayHours']
        wednesday_hours = data['WednesdayHours']
        thursday_hours = data['ThursdayHours']
        friday_hours = data['FridayHours']

        # Establish a connection to the database
        cursor = cnxn.cursor()

        # Execute the SQL query to insert the timesheet entry
        query = f"""
        INSERT INTO TimesheetEntries (UserID, ProjectName, WeekNumber, WeekStartDate, WeekEndDate,
                                      MondayHours, TuesdayHours, WednesdayHours, ThursdayHours, FridayHours)
        VALUES ((SELECT UserID FROM Users WHERE FirstName = '{first_name}'), '{project_name}', {week_number},
                '{week_start_date}', '{week_end_date}', {monday_hours}, {tuesday_hours}, {wednesday_hours},
                {thursday_hours}, {friday_hours})
        """

        cursor.execute(query)

        # Commit the changes to the database
        cnxn.commit()

        # Return a success message
        return jsonify({'message': 'Timesheet entry created successfully'})

    except Exception as e:
        # Add appropriate exception handling, logging, and error handling here
        print(f"An error occurred: {str(e)}")
        return jsonify({'error': 'An error occurred'}), 500

#DELETE API routes for the application

# Define a DELETE route to remove a user
@app.route('/users/<first_name>', methods=['DELETE'])
def delete_user(first_name):
    try:
        cursor = cnxn.cursor()
        
        # Check if user exists
        cursor.execute("SELECT UserID FROM Users WHERE FirstName = ?", first_name)
        row = cursor.fetchone()
        if row is None:
            return jsonify({'error': 'User not found'}), 404
        
        # Delete dependent rows in UserProjects table
        cursor.execute("DELETE FROM UserProjects WHERE UserID = ?", row.UserID)
        
        # Delete user
        cursor.execute("DELETE FROM Users WHERE FirstName = ?", first_name)
        cnxn.commit()
        
        return jsonify({'message': f'{first_name} deleted successfully'})
    
    except pyodbc.DatabaseError as e:
        cnxn.rollback()
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
    app.run(port=5000, debug=True)


    