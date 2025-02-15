# What Does This Do?

This script automates the setup of a basic web server on a Debian-based system. It installs and configures Apache, PostgreSQL, and UFW.

# How to Use It in CLI

1. Download the script:

   ```sh
   wget https://your-repo-url/setup_server.sh
   ```

2. Make the script executable:
    ```sh
    chmod +x setup_server.sh
    ```

3. Run as sudo:
    ```sh
    sudo DB_NAME=your_database DB_USER=your_user DB_PASS=your_password ./setup_server.sh
    ```

