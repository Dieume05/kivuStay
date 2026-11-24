# KivuStay
## Tourism and Accommodation Booking Platform

KivuStay is a web-based accommodation booking platform developed as part of the CSE402 – Advanced Web and Internet Programming FAT Project.

The system connects guests with accommodation providers and allows users to search for hotels, check room availability, calculate booking costs, and make reservations.

Hotel managers can manage rooms, monitor bookings, and view accommodation statistics through a dedicated management dashboard.

### Main Features

- User registration and authentication.
- Hotel search and room availability checking.
- Online room booking and cancellation.
- Booking price calculation.
- Manager dashboard and room management.
- Booking and occupancy analytics.
- Trip Planner for organizing shortlisted stays.
- XML data export and transformation.
## Tools and Technologies

| Tool / Technology | Version |
|---|---|
| IDE | Eclipse IDE for Enterprise Java and Web Developers |
| Java Execution Environment | JavaSE-25 |
| Apache Tomcat | 9.0 |
| MySQL Server | 8.0 |
| MySQL Connector/J | 26.10.0 |
| Backend | Java Servlets and JSP |
| Frontend | HTML, CSS, Vanilla JavaScript |
| Database Connectivity | JDBC |
| Database | MySQL |
## Database Setup

KivuStay uses MySQL 8.0 as its relational database management system.

### Database Name

`kivustay`

### Setup Instructions

1. Start the MySQL Server.
2. Open MySQL Workbench or MySQL Command Line Client.
3. Execute the SQL scripts provided in the project:
   - `schema.sql` – Creates the database tables and relationships.
   - `seed.sql` – Inserts sample data for testing.
4. Verify that the `kivustay` database has been created successfully.

Database Connection Configuration

KivuStay uses JDBC to connect to the MySQL database. Database connection settings are configured through context parameters in:

"src/main/webapp/WEB-INF/web.xml"

The following parameters are used:

Parameter| Description
"db.url"| MySQL JDBC connection URL
"db.username"| MySQL database username
"db.password"| MySQL database password

The default connection URL is:

"jdbc:mysql://localhost:3306/kivustay?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"

Before running the application, ensure that the database credentials in "web.xml" match your local MySQL configuration.

Important: For deployment, use a dedicated MySQL application account with appropriate database permissions rather than the MySQL root account. Do not publish database passwords in the README or public repositories.

## Installation and Deployment

### Prerequisites

Before running KivuStay, ensure that the following are installed:

- Eclipse IDE for Enterprise Java and Web Developers.
- Java Development Kit (JDK).
- Apache Tomcat 9.0.
- MySQL Server 8.0.

### Importing the Project

1. Open Eclipse.
2. Select **File → Import**.
3. Choose **Existing Projects into Workspace**.
4. Browse to the extracted KivuStay project folder.
5. Select the project and click **Finish**.
6. Ensure that Apache Tomcat 9.0 is configured in Eclipse.

### Running the Application

1. Start MySQL Server.
2. Ensure the `kivustay` database is configured.
3. Right-click the KivuStay project.
4. Select **Run As → Run on Server**.
5. Choose Apache Tomcat 9.0.
6. Open the application in your browser using the configured local URL.
## Application Access

Once the application is successfully deployed on Tomcat, access it through:

**Local URL:** http://localhost:8080/KivuStay/
## Test Accounts

The following accounts can be used to test the application.

### Manager Account

- Email: jean.manager@kivustay.com
- Password: Manager@123
- Role: MANAGER

### Guest Account

- Email: testguest@kivustay.com
- Password: Guest123
- Role: GUEST
## Project Structure

The project follows a layered architecture that separates request handling, business logic, database operations, and presentation.

- `src/main/java/` – Java source code.
  - `com.kivustay.servlet` – Handles HTTP requests and responses.
  - `com.kivustay.dao` – Handles database operations.
  - `com.kivustay.model` – Contains application data models.
  - `com.kivustay.util` – Contains utility classes.
  - `com.kivustay.exception` – Contains custom exceptions.
- `src/main/webapp/` – Contains JSP pages, CSS, JavaScript, and other web resources.
- `WEB-INF/lib/` – Contains external libraries, including MySQL Connector/J.
## Application URLs

All URLs use the following base address:

`http://localhost:8080/KivuStay`

| Feature | URL |
|---|---|
| Home Page | `/` |
| Login Page | `/login.jsp` |
| Search Accommodations | `/search` |
| Booking | `/guest/book` |
| Booking Details | `/guest/booking-details` |
| Guest Dashboard | `/guest/dashboard` |
| Trip Planner | `/trip-planner.jsp` |
| Booking Quote | `/quote` |
| Manager Dashboard | `/manager/dashboard` |
| Manager Room Management | `/manager/rooms` |
| Currency Preference | `/preferences/currency` |
## User Roles

KivuStay provides two main user roles:

### Guest
- Search for available accommodations.
- View accommodation details.
- Check room availability.
- Calculate booking costs.
- Make and cancel reservations.
- Organize shortlisted accommodations using the Trip Planner.

### Manager
- Access the manager dashboard.
- Add, edit, and delete rooms.
- Manage accommodation information.
- View and manage reservations.
- Monitor occupancy statistics and analytics.
## Testing and Quality Assurance

KivuStay was tested to verify the reliability, security, and correctness of its main features.

The testing activities included:

- **Authentication:** Verification of user login and role-based access.
- **Room Management:** Testing room creation, editing, and deletion.
- **Booking:** Testing booking operations and transaction conflict handling.
- **Availability:** Testing room availability and search functionality.
- **SQL Injection:** Testing search input against SQL injection attempts.
- **CSRF Protection:** Verification of CSRF token validation for manager room operations.
- **Frontend Testing:** Execution of 15 QUnit tests.
- **Dashboard:** Verification of manager analytics and occupancy charts.

Testing was performed during development to identify and correct errors before deployment.
## System Architecture

KivuStay uses a layered architecture based on the Model-View-Controller (MVC) pattern and Data Access Object (DAO) pattern.

The application is organized into the following layers:

1. **Presentation Layer:** JSP, HTML, CSS, and JavaScript provide the user interface.
2. **Controller Layer:** Java Servlets receive HTTP requests, process user actions, and coordinate application operations.
3. **Model Layer:** Java model classes represent application entities and their data.
4. **Data Access Layer:** DAO classes handle database operations using JDBC and PreparedStatement.
5. **Database Layer:** MySQL stores users, accommodations, rooms, bookings, and related information.

This separation improves maintainability, code organization, and the separation of responsibilities.

## Security Features

KivuStay incorporates several security measures to protect application data and user operations.

- **Authentication:** Users must log in to access protected features.
- **Role-Based Access Control:** Guests and managers have different permissions.
- **Prepared Statements:** JDBC PreparedStatement is used to execute database queries and reduce SQL injection risks.
- **CSRF Protection:** CSRF tokens are validated for manager room-management POST requests.
- **Session Management:** User sessions are used to maintain authentication state.
- **Input Validation:** User inputs are validated before processing.

Troubleshooting

The following issues may occur when setting up or running KivuStay:

Problem| Possible Solution
MySQL connection failed| Ensure MySQL Server is running and verify the database URL, username, and password in "WEB-INF/web.xml".
Database does not exist| Execute "schema.sql" to create the "kivustay" database.
Application fails to deploy| Verify that Apache Tomcat 9.0 is configured correctly in Eclipse.
HTTP 404 error| Check the application context path and requested URL.
JDBC driver not found| Ensure MySQL Connector/J is included in "WEB-INF/lib/".
Login fails| Verify the account credentials and confirm that the user exists in the database.

For additional assistance, check the Eclipse Console and Apache Tomcat logs for error messages.