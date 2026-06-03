# LOP Team B - Library Project

This repository contains a university h-da course project focused on a Library Management Application with Common Lisp, developed by **Team B**:
* `Florian LOPITAUX`
* `Julien SCHIELER`
* `Yassine NAZIR`
* `Yun Fang Chin`

The primary goal of this project is to design and manage a book borrowing and payment system using the Common Lisp environment.

## 📁 Repository Architecture

The repository is structured as follows:

```text
.
├── better_lang/    # The modified language extension package (required)
├── library_app/    # The main source code for the Library Application
├── docs/           # The library documentation like UML diagram and other stuff (ToDo not yet added)
├── .gitignore      # Git ignore file (filters out .fasl compilation files, etc.)
└── README.md       # This documentation file
```

## 🚀 Quick Start
To load the project into your Allegro editor :
clone the repository main branch

```shell
git clone https://github.com/florianLopitaux/LOP_Library.git
```

Then, in Allegro editor, open a project and search the `library_app/library-app.lpr` file. <br>
And that's it 🎉 the code project should compile and you will be able to use.

## ⚠️ Important Configuration

> [!CAUTION]
> **Do not use the standard `lang` package.** You must use the **`better_lang`** package included in this repository.
> Otherwise, the application will fail to compile and run. <br>
> Normally, the default configuration should use `better_lang` first (do not separate *better_lang* and *library_app* folders because the default path will be wrong)

##### Next Caution for project developers only
> [!CAUTION]
> **Do not push `.fasl` files !** They are Allegro compilation files and should not be pushed on the repository because they contains path of your machine like C:\Users\MyName\... <br>
> Normally, that should not happen because `.fasl` files are ignored by the `.gitignore` but be carefull please 🥺.

## 📋 Naming Conventions & Guidelines

To ensure code consistency and seamless integration with our better_lang extension features, all team members must strictly follow these naming conventions:

**1. Mandatory**
---

- **Enumerations** *(def-enum)*: Must start with a lowercase `e` followed by the name in UpperCamelCase (with the very first character capitalized).
> Example: eCustomerRole, eTransactionReference

- **Custom Types** *(def-data-type)*: Must start with a lowercase `t` followed by the name in UpperCamelCase (with the very first character capitalized).
> Example: tFullName, tDate

**2. Optional (only for code consistency and seamless)**
---

- **Structures** *(def-struct)*: Must start with a lowercase s followed by the name in UpperCamelCase (with the very first character capitalized).
> Example: sBookItem, sBorrowingRecord

- **Classes** *(def-class or def-entity)*: Written in standard CamelCase with the very first character capitalized (UpperCamelCase).
> Example: Customer, Transaction, BookItem

- **Functions** *(def-function)*: Written in classic lowerCamelCase (starts with a lowercase letter, then capitalizes the first letter of each subsequent word).
> Example: subscribeNewCustomer, makePayment, findAllStudents

- **Variables & Parameters**: Written in lowercase, with words separated by a hyphen : `-`.
> Example: my-var, customer-name
