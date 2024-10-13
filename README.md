# Getting Started with Officelime Web Application Framework (OWAF)

This guide will walk you through the steps to set up a web application using the Officelime Web Application Framework (OWAF) development environment.

## Requirements

To successfully run OWAF, you will need the following:

- **[Lucee Server 5](https://cdn.lucee.org/lucee-express-5.4.6.9.zip)** (version 6 is not supported)
- **[MySQL 8+](https://dev.mysql.com/downloads/installer/)**
- **[OWAF code base](https://github.com/officelimex/owaf3)**

## Setup

1. **Download the Source Code**

   Download the OWAF source code from the [Officelime OWAF3 GitHub repository](https://github.com/officelimex/owaf3) to your Lucee server's ROOT directory.

2. **Copy the Example Project**

   Copy the `project1` folder inside the `_example` folder to the Lucee server's ROOT directory. Your directory structure should look like the following:
  
    ROOT/
      - project1/
      - owaf3/
      - WEB-INF/
      - favicon.ico
      - assets/
      - Application.cfc
      - index.cfm

3. **Rename the Project Folder (Optional)**

You can rename the `project1` folder to match your project's name. For this demonstration, we'll continue using `project1`.

## Project Folder Structure

Within your project folder, you will find the following important directories:

- **assets/**  
This folder contains your app's assets (JavaScript, CSS, images, fonts, etc.).

- **controllers/**  
OWAF uses the MVC (Model-View-Controller) approach, and this folder houses all your controller `.cfc` files.

- **owaf/**  
This is a crucial folder for OWAF's functionality. It contains core components, tags, and helper functions that link to the main OWAF framework outside of your project directory.

- **models/**  
This folder holds the `.cfc` files for the models used in your project.

- **views/**  
This folder contains the views, designs, and UI elements of your app.

## Contribute to the Documentation

If you have suggestions to improve this documentation, feel free to contribute by submitting an issue or a pull request on the [OWAF GitHub repository](https://github.com/officelimex/owaf3).
