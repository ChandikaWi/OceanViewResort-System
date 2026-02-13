# 🌊 Ocean View Resort Management System

![Java](https://img.shields.io/badge/Java-17-orange)
![Platform](https://img.shields.io/badge/Platform-Web-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVC%20%7C%20REST-green)
![Build](https://img.shields.io/badge/Build-Maven-red)

> A distributed enterprise web application for managing hotel reservations, room bookings, and financial analytics. Built using Java EE, MVC Architecture, and RESTful Web Services.

---

## 📖 Table of Contents
- [🏨 About the Project](#-about-the-project)
- [🚀 Key Features](#-key-features)
- [🏗 System Architecture](#-system-architecture)
- [💻 Technology Stack](#-technology-stack)
- [🔌 REST API Documentation](#-rest-api-documentation)
- [⚙ Setup & Installation](#-setup--installation)
- [🧪 Testing Strategy](#-testing-strategy)

---

## 🏨 About the Project

The **Ocean View Resort Management System** is a robust software solution designed to streamline hotel operations. It transitions from a traditional desktop approach to a **Distributed Web Application**, allowing real-time booking management, automated guest communication, and executive decision-making through data visualization.

The system implements **Role-Based Access Control (RBAC)** to secure sensitive administrative functions while providing a seamless experience for front-desk staff.

---

## 🚀 Key Features

### 🔐 Security & Access Control
- **Secure Authentication:** Encrypted login sessions for Admin and Staff.
- **RBAC:** Strict separation of duties (e.g., only Admins can manage room inventory).
- **Session Management:** Auto-logout and URL protection against unauthorized access.

### 📅 Reservation Management
- **Real-time Availability:** Prevents double-booking by checking live database inventory (`RoomTypeDAO`).
- **Dynamic Pricing:** Auto-calculates total bill based on room rates and duration.
- **Search & Filter:** Instantly locate guest records by ID or Name.

### 📧 Automation & Reporting
- **Async Email Service:** Sends HTML Booking Confirmations and PDF Invoices via Gmail SMTP using multi-threading (non-blocking).
- **PDF Generation:** Auto-generates professional invoices using the **iText** library.
- **Executive Dashboards:** Visual analytics (Polar Area, Bar, Line charts) powered by **Chart.js**.

### 🌐 Distributed Services (REST API)
The system exposes a JSON-based API layer (`com.oceanview.api`), allowing external applications to consume hotel data.

---

## 🏗 System Architecture

The project follows the **Model-View-Controller (MVC)** design pattern to ensure separation of concerns:

- **Model:** Java POJOs and DAOs (Data Access Objects) handling business logic and database interactions.
- **View:** JSP (JavaServer Pages) with HTML5/CSS3 and Chart.js for the frontend.
- **Controller:** Java Servlets managing HTTP requests and API endpoints.

### Design Patterns Used
- **DAO Pattern:** Abstracts database operations.
- **Singleton Pattern:** Manages database connection.
- **Front Controller Pattern:** Centralized request handling.

---

## 💻 Technology Stack

### Backend
- **Language:** Java (JDK 17)
- **Framework:** Java Servlets, JSP
- **Database:** MySQL (JDBC)
- **Build Tool:** Apache Maven
- **Testing:** JUnit 5

### Frontend
- **Structure:** HTML5, CSS3 (Responsive)
- **Scripting:** JavaScript (ES6)
- **Libraries:** Chart.js (Analytics), FontAwesome (Icons)

### Utilities
- **PDF Engine:** iText Library
- **Email Engine:** JavaMail API
- **Server:** Apache Tomcat 9.0+

---

## 🔌 REST API Documentation

| Method | Endpoint | Description |
|--------|----------|------------|
| `GET`  | `/api/rooms`        | Retrieve a JSON list of all available room types and prices |
| `GET`  | `/api/stats`        | Retrieve real-time financial stats (Revenue, Bookings) |
| `POST` | `/api/reservations` | Create a new reservation remotely (Requires JSON payload) |

### Example Response – `GET /api/rooms`

```json
[
  {
    "id": 2,
    "typeName": "Luxury Suite",
    "price": 150.00,
    "quantity": 5
  }
]
```

---

## ⚙ Setup & Installation

### Prerequisites

- Java Development Kit (JDK) 17 or higher
- Apache Maven
- MySQL Server (XAMPP/WAMP optional)
- Apache Tomcat 9.0+

---

### 1. Database Setup

Import the `oceanview_db.sql` file into MySQL:

```sql
CREATE DATABASE oceanview_db;
USE oceanview_db;
CREATE DATABASE IF NOT EXISTS oceanview_db;
USE oceanview_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, 
    role VARCHAR(20) DEFAULT 'STAFF'
);

INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'ADMIN');

CREATE TABLE IF NOT EXISTS reservations (
    res_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact_number VARCHAR(20),
    room_type VARCHAR(50),
    check_in DATE,
    check_out DATE,
    total_cost DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE reservations MODIFY res_id INT NOT NULL;

CREATE TABLE IF NOT EXISTS room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    image_url VARCHAR(255) 
);

INSERT INTO room_types (type_name, price, description, image_url) VALUES 
('Standard', 80.00, 'Comfortable room with garden view.', 'images/Standard_Room.jpg'),
('Luxury Suite', 150.00, 'Luxury suite with ocean view.', 'images/Luxury_Suite.jpg');

ALTER TABLE reservations ADD email VARCHAR(100) AFTER contact_number;

ALTER TABLE room_types ADD quantity INT NOT NULL DEFAULT 5;
```

---

### 2. Application Configuration

Update `DBConnection.java` with your credentials:

```java
private static final String URL = "jdbc:mysql://localhost:3306/oceanview_db";
private static final String USER = "root";
private static final String PASS = "";
```

---

### 3. Build & Run

```bash
git clone https://github.com/ChandikaWi/OceanViewResort-System.git
cd OceanViewResort-System
mvn clean install
```

Deploy the generated `.war` file to your Tomcat `webapps` directory.

---

## 🧪 Testing Strategy

The system follows **Test-Driven Development (TDD)** principles.

### Unit Tests
- JUnit 5 tests verify:
  - Cost calculation logic
  - Model validation
  - Business rules

### Integration Tests
- Database connectivity
- Reservation & inventory logic

### Run Tests

```bash
mvn test
```

---

## 📄 License

This project is for educational purpose.

---

## 👨‍💻 Author

Developed by **A.G.Chandika Wickramasena**  
GitHub: https://github.com/ChandikaWi
