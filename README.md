# Deep Links in Flutter

A complete Flutter project demonstrating **Deep Links** (App Links / Universal Links) for Android and iOS.

---

## 📌 Overview

Deep Links allow your app to navigate users directly to a specific page or content, instead of just opening the app. This improves user experience and engagement.

**Example use cases:**
- Open a product page directly from a link
- Apply promo codes via a link
- Search directly in the app with pre-filled queries

---

## 🛠 Features

- Support for **Android App Links** and **iOS Universal Links**
- Handle **Cold Start** (app opened via link) and **Warm Start** (app already running)
- Stream-based listener to react to incoming links in real-time
- Supports multiple link types:
  - `/product/:id`
  - `/search?q=...&filter=...`
  - `/promo/:code`
  - Unknown links fallback

---

## Demo for project

https://github.com/user-attachments/assets/97447e1e-8c89-4201-a627-66a1fe91c0a2

