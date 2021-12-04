# Flutter-E-commerce-App
<p align="center">
<img src="https://user-images.githubusercontent.com/32794378/141204109-bb23af7a-9f26-411b-ba15-e7550a9218ae.png" alt="Logo" width="120">
</p>
<h3 align="center">MyBRAND<br><br>
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/ISL270/Flutter-E-commerce-App">
<img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/ISL270/Flutter-E-commerce-App">
<img src="https://visitor-badge.glitch.me/badge?page_id=ISL270.Flutter-E-commerce-App&right_color=red&left_text=visitors" /></h3>

## About
I developed a fully functioning e-commerce flutter application that is compatible with both iOS & Android.  I built it with the MVVM
( Model-View-ViewModel ) architecture, and I used [**Firebase Authentication**](https://firebase.google.com/products/auth) to securely authenticate users, [**Cloud Firestore**](https://firebase.google.com/products/firestore) to store product details & users' data, [**Firebase Storage**](https://firebase.google.com/products/storage) to store product images, and [**Provider**](https://pub.dev/packages/provider) for state management.

**Note:** I didn't include my `GoogleService-Info.plist` & `google-services.json` files for obvious reasons, so you have to set up your own firebase project to be able to host this application, otherwise it won't work.

## Preview
![Preview](/gifDemo.gif)

## Features
- **Sign-in, Sign-up, Reset password, Log-out.**
- **Users can edit their information** (Name, Phone number, Address).
- **View products by category.**
- **Search for a product** (currently being implemented).
- **Cache images for faster load times.**
- **Zoom-in on images.**
- **Maintain cart.**
- **Make an order.**
- **View orders status.**
- **All of the above is synced with the database.**
- **Animated buttons with alert messages.**
- **Animated images & navigation bar.**

## Screenshots
| Home_Screen | Product_Screen | Category_Screen |
| :---: | :---: | :---:|
| ![Home](https://user-images.githubusercontent.com/32794378/141525691-e93a3856-3438-4eb4-af4f-2a99a0138d26.png) | ![Product](https://user-images.githubusercontent.com/32794378/141521230-4112a4c4-f4c1-42b8-b4d4-05bf6eb61016.png) | ![Category](https://user-images.githubusercontent.com/32794378/141521319-a3c85d06-f9e5-49f1-b0b0-31d905717a73.png) |
| SignIn_Screen | SignUp_Screen | Profile_Screen |
| ![Sign-in](https://user-images.githubusercontent.com/32794378/141522895-47275cb5-0ea8-4195-afe6-c38a49e8ba81.png) | ![Sign-up](https://user-images.githubusercontent.com/32794378/141522926-7047c432-fe55-452d-a2f1-2e78d376de1d.png) | ![Profile](https://user-images.githubusercontent.com/32794378/141523046-14edc430-2cfb-4569-bd1b-e0b674248d2d.png) |
| Cart_Screen | CheckOut_Screen | Orders_Screen |
| ![Cart](https://user-images.githubusercontent.com/32794378/141523345-286e79b0-43a8-4555-a371-d4eb1b4b0a6a.png) | ![Checkout](https://user-images.githubusercontent.com/32794378/141523381-f9ebb661-1b55-42f6-a91e-b5bcc4fec540.png) | ![Orders](https://user-images.githubusercontent.com/32794378/141523430-a086dd42-040e-4908-ba62-e7499a194471.png) |

## Resources
The following resources were used during the development of this project:
- [**Dart documentation**](https://dart.dev/guides)
- [**Flutter documentation**](https://flutter.dev/docs)
- [**FlutterFire documentation**](https://firebase.flutter.dev/docs/overview)
- [**Flutter Apprentice Book**](https://www.raywenderlich.com/books/flutter-apprentice/v2.0)
- [**Stack Overflow: Flutter**](https://stackoverflow.com/questions/tagged/flutter)
- [**Some UI inspirations**](https://github.com/abuanwar072/E-commerce-Complete-Flutter-UI)

**Note:** I uploaded this project to github only to showcase my work and you cannot use it commercially by any means.

