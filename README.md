# Auto Parts E-Commerce Database Project

## 1. Project Overview
This project involves the comprehensive design and implementation of a database for a multi-vendor B2C e-commerce platform dedicated to automotive parts. The system is designed to handle complex requirements such as vehicle-part compatibility, multi-vendor inventory, and real-time stock management.

### Key Experiences & Features
*   **Vehicle-Part Compatibility**: Optimized schema for managing part compatibility with specific vehicle makes, models, and years.
*   **Multi-Vendor Model**: Flexible structure allowing the same part to be sold by multiple sellers with different pricing and stock levels.
*   **Stock Management**: Integrated system for real-time stock tracking, automatic updates via triggers, and low-stock alerts.
*   **Personalized Experience**: Support for filtering and recommendations based on a user's registered vehicle.
*   **Verified Purchase Reviews**: ensuring only actual buyers can leave reviews for parts.

## 2. File Structure
The project consists of four main SQL scripts that should be executed in order:

*   **`01_schema.sql`**: Defines the database structure. Creates all tables (Users, Parts, Vehicles, Orders, etc.) with appropriate relationships and constraints.
*   **`02_triggers.sql`**: Contains stored procedures and triggers to enforce business logic (e.g., updating stock on order, preventing negative stock, generating order numbers).
*   **`03_seed_data_full.sql`**: Populates the database with initial sample data for testing (Users, Cars, Parts, Inventory, Orders).
*   **`04_demo_queries_and_crud_examples.sql`**: A collection of demonstration queries showing CRUD operations, reporting views, and complex joins to verify system functionality.

## 3. How to Run
To set up the database, execute the scripts in the following order using your preferred MySQL client (e.g., MySQL Workbench, DBeaver, or command line):

1.  **Run `01_schema.sql`**: This will create the `auto_parts_ecommerce` database and all necessary tables.
2.  **Run `02_triggers.sql`**: This will install triggers and stored procedures.
3.  **Run `03_seed_data_full.sql`**: This will insert test data.
4.  **Run `04_demo_queries_and_crud_examples.sql`**: This will execute test queries and generate reports.

_Note: The scripts are designed to be idempotent or clean up after themselves (using `DROP IF EXISTS` where appropriate)._

## 4. Advanced Capabilities implemented
The system supports advanced operations including:
*   **Bulk Updates**: Capability to update prices across entire categories (e.g., 10% increase).
*   **Archiving**: Automated moving of old, delivered orders to an `archive_orders` table to keep the main table performant.
*   **Account Merging**: Administrative ability to merge customer data and history from one account to another.
*   **Complex Analysis**: Queries for "Customer Purchase Analysis" and identifying "Slow-moving Inventory".

## 5. Future Roadmap & Impact
The database design accounts for future technologies and broader impacts:
*   **AI Integration**: Ready for intelligent recommendation engines and price optimization algorithms.
*   **IoT & Telemetry**: Potential for real-time part performance monitoring and predictive maintenance integration.
*   **Supply Chain**: Structured to support transparency and logistics optimization, contributing to carbon footprint reduction.
