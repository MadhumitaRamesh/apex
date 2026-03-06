# Apex — Market Intelligence Dashboard

Apex is a real-time price comparison and analysis tool. It scouts products across Amazon and Flipkart, providing live data to help you find the best value without manual searching.

## What it does

- **Real-time Scouting**: Directly parses HTML from ecommerce sites for the most up-to-date pricing.
- **Deep Analytics**: Calculates market averages, identifies the lowest prices, and provides a "Buy/Wait" verdict.
- **Personal Hub**: Save products to your profile to track them over time.
- **Visual Insights**: Uses Chart.js to show price trajectories and variant comparisons.
- **Profile Management**: Full account settings with secure Firebase persistence.

## Design

The app uses a modern **Indigo-Violet** theme with a focus on speed and clarity. It's built to look professional and feel responsive, using a clean light-mode aesthetic.

## Tech Stack

- **Java 17+** with Jakarta EE Servlets
- **JSP & Vanilla CSS** for a fast, zero-framework frontend
- **Jsoup** for the extraction engine
- **Firebase** for the real-time database
- **Maven & Tomcat 10** for the build and execution

---

## How to run it locally

1. **Clone the repo** to your machine.
2. Ensure you have **Java 17** and **Maven** installed.
3. (Optional) Add your Firebase `serviceAccountKey.json` to `src/main/resources/` for the Hub features.
4. Open a terminal in the project folder and run:
   ```bash
   mvn cargo:run
   ```
5. Access the app at: **[http://localhost:8080/Apex](http://localhost:8080/Apex)**

---
Developed as a professional price intelligence solution.
