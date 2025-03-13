# Daakia Video Conference Flutter SDK - Example

This example demonstrates how to integrate the Daakia Video Conference Flutter SDK with user input for meeting credentials.

## Prerequisites

* Flutter SDK installed.
* Valid `meetingId` and `secretKey` (license key) obtained from [Daakia](https://www.daakia.co.in/).

## Setup

1.  **Clone & Get Dependencies:**
    ```bash
    git clone [repository_url]
    cd [repository_directory]/example
    flutter pub get
    ```
2.  **Run the App:**
    ```bash
    flutter run
    ```

## Usage

* Enter your `License Key` and `Meeting UID` into the provided text fields.
* Use the "Host" toggle to specify if you are the meeting host.
* Tap the "Test SDK" button to initiate the video conference using the entered credentials.
* The app validates the input fields; an error message is displayed if any field is empty.

## Support

For assistance, please contact [contact@daakia.co.in](mailto:contact@daakia.co.in).