
This project sets up a LAMP stack with SuiteCRM using Docker. The configuration includes Apache, MySQL, PHP, and Xdebug for debugging. The Apache configuration is customized to serve SuiteCRM.

## Prerequisites

- Docker installed on your machine

```bash
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

## Building the Docker Image

To build the Docker image, navigate to the project directory and run the following command:

``` sh
docker build -t my-lamp-suitecrm .
```
## Running the Docker Container

Once the image is built, you can run the Docker container with the following command:
``` sh
docker run -d -p 8080:80 -p 3306:3306 -p 9003:9003 --name my-lamp-container my-lamp-suitecrm
```
This command will start a container named my-lamp-container and map the following ports:
- 8080 to 80 (Apache)
- 3306 to 3306 (MySQL)
- 9003 to 9003 (Xdebug)

## Apache Configuration

The Apache configuration is defined in the apache_config.config file. This configuration sets up the virtual host to serve SuiteCRM from /var/www/html/SuiteCRM-7.11.23.

``` sh
<VirtualHost *:80>
    DocumentRoot /var/www/html/SuiteCRM-7.11.23
    <Directory /var/www/html/SuiteCRM-7.11.23>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
## Accessing SuiteCRM

After running the container, you can access SuiteCRM by navigating to http://localhost:8080 in your web browser.

## Stopping the Docker Container

To stop the running container, use the following command:
``` sh
docker stop my-lamp-container
```
To remove the container, use:

``` sh
docker rm my-lamp-container
```

## Additional Information

- The Dockerfile installs all necessary packages, including Apache, MySQL, PHP, and Xdebug.
- The SuiteCRM application is downloaded and installed in /var/www/html/SuiteCRM-7.11.23.
- Apache is configured to serve SuiteCRM and allow overrides for .htaccess files.

Feel free to customize the configuration files as needed for your specific use case.
