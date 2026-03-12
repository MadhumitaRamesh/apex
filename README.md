# Apex — Market Intelligence Dashboard

> Real-time price comparison across Amazon & Flipkart, with a full admin console, user activity tracking, and price history analytics.

---

## ✨ Features

| Feature | Details |
|---|---|
| 🔍 **Price Scouting** | Live scraping of Amazon India & Flipkart — no cached data |
| 📊 **Deep Analytics** | Market average, lowest price, MRP vs sale, Buy/Wait verdict |
| 📈 **Price History** | Chart.js price trajectory over time per product |
| 🛒 **Personal Hub** | Save products, track them, manage your watchlist |
| 👤 **Auth System** | Register, login, role-based access (user / admin) |
| 🛡️ **Admin Console** | Manage users, restrict/promote/delete, provision new admins |
| 📋 **System Logs** | Full audit trail of all logins, logouts, and admin actions |
| 🤖 **Scraper Monitor** | Real-time scraper status page |
| 🔔 **Alert Service** | Price drop alerts dispatched to users |

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Web Layer | Jakarta EE Servlets + JSP |
| Frontend | Vanilla CSS + JavaScript (Chart.js) |
| Scraping | [Jsoup](https://jsoup.org/) — Amazon HTML parser + Flipkart Rome API |
| Database | [Firebase Realtime Database](https://firebase.google.com/) |
| Build | Maven 3 |
| Server | Apache Tomcat 10 (embedded via Cargo Maven plugin) |

---

## ⚙️ Prerequisites

Make sure you have the following installed before running the project:

- **Java 17+** — `java -version`
- **Maven 3.6+** — `mvn -version`
- A **Firebase project** with Realtime Database enabled

---

## 🔑 Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) → your project → **Project Settings → Service Accounts**
2. Click **Generate new private key** — this downloads a `serviceAccountKey.json`
3. Place the file here in the project:
   ```
   src/main/webapp/WEB-INF/serviceAccountKey.json
   ```
   > ⚠️ This file is in `.gitignore` — never commit it.

The database URL is already configured to:
```
https://apex-price-scout-default-rtdb.asia-southeast1.firebasedatabase.app/
```

---

## 🚀 Running Locally

### 1. Clone the repository

```bash
git clone https://github.com/MadhumitaRamesh/apex.git
cd apex
```

### 2. Add your Firebase key

```bash
# Place your downloaded serviceAccountKey.json into:
cp ~/Downloads/serviceAccountKey.json src/main/webapp/WEB-INF/serviceAccountKey.json
```

### 3. Build the project

```bash
mvn clean package
```

### 4. Start the server

```bash
mvn cargo:run
```

The server starts on **port 8080**. You'll see Firebase initialization logs in the terminal.

### 5. Open the app

| Page | URL |
|---|---|
| 🏠 Homepage | [http://localhost:8080/Apex/](http://localhost:8080/Apex/) |
| 🔐 User Login | [http://localhost:8080/Apex/login.jsp](http://localhost:8080/Apex/login.jsp) |
| 📝 Register | [http://localhost:8080/Apex/register.jsp](http://localhost:8080/Apex/register.jsp) |
| 🛡️ Admin Login | [http://localhost:8080/Apex/admin_login.jsp](http://localhost:8080/Apex/admin_login.jsp) |
| 🖥️ Admin Dashboard | [http://localhost:8080/Apex/admin_dashboard](http://localhost:8080/Apex/admin_dashboard) *(requires admin session)* |
| 📋 System Logs | [http://localhost:8080/Apex/system_logs](http://localhost:8080/Apex/system_logs) *(requires admin session)* |

---

## 🗂️ Project Structure

```
Apex/
├── src/main/
│   ├── java/com/apex/
│   │   ├── config/
│   │   │   └── FirebaseConfig.java       # Firebase init on server startup
│   │   ├── filters/
│   │   │   └── AuthFilter.java           # Session / auth guard
│   │   ├── models/
│   │   │   ├── PricePoint.java
│   │   │   ├── ScrapedProduct.java
│   │   │   └── User.java
│   │   ├── scraper/
│   │   │   └── ScraperEngine.java        # Amazon + Flipkart scrapers
│   │   ├── services/
│   │   │   ├── AlertService.java
│   │   │   ├── AnalyticsService.java
│   │   │   └── PricingService.java
│   │   └── servlets/
│   │       ├── AdminServlet.java         # /admin_dashboard, /system_logs
│   │       ├── AuthServlet.java          # /auth (login, register, logout)
│   │       ├── CartServlet.java
│   │       ├── DetailsServlet.java       # /details (product deep-dive)
│   │       └── SearchServlet.java        # /search
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   └── serviceAccountKey.json    # ← YOU ADD THIS (gitignored)
│       ├── css/styles.css
│       ├── includes/navbar.jsp
│       ├── index.jsp
│       ├── login.jsp / register.jsp
│       ├── admin_login.jsp
│       ├── admin_dashboard.jsp
│       ├── system_logs.jsp
│       ├── dashboard.jsp
│       ├── details.jsp
│       ├── results.jsp
│       ├── settings.jsp
│       └── scraper_status.jsp
└── pom.xml
```

---

## 🛡️ Admin Console

To access the admin panel, create a user in Firebase with `"role": "admin"`, then log in via `/admin_login.jsp`.

The admin console lets you:
- View and manage all registered users
- Restrict / activate / promote / delete users
- Provision new administrator accounts
- View the full **System Activity Logs** with colour-coded event types

---

## 🔧 Common Commands

```bash
# Build only (no server start)
mvn clean package

# Build and run on Tomcat 10 at port 8080
mvn cargo:run

# Run tests (if present)
mvn test

# Clean build artifacts
mvn clean
```

---

## 📌 Notes

- The scraper hits Amazon India and Flipkart live — results depend on their current page structure. If scraping fails, the app gracefully shows a fallback message.
- First admin login seeds sample System Log entries into Firebase if the `activities` node is empty.
- Passwords are stored as plaintext in this prototype — hash them before any production use.

---

*Developed as a professional price intelligence solution.*
