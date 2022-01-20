# Inventory Manager
## Jarod Rankin

This inventory manager application is designed to meet the requirements of the Shopify Backend Intern [job application](https://jobs.smartrecruiters.com/Shopify/743999796499290-backend-developer-intern-summer-2022-remote-us-canada-) requirements.

This inventory manager application uses ruby 3.1.0 and rails 7.0.1, [rails setup](https://guides.rubyonrails.org/getting_started.html).

To get the program running you can run the following commands from the inventory directory,
<source ~/.bashrc>
Chruby 3.1.0
rake db:migrate
bin/rails server

bin/rails server will start the server from there you can send API requests to it, routes for each function are found in 
the routes.rb file. This will prompt the functions to work with sku's in the database's created when we rake our
database migrations. 

I have created some units tests under the file inventories_controller_test.rb, when you run rails test from the inventory directory
you should expect to get 9 runs, 15 assertions and no errors, failures or skips.



## API Features

- Creation of a Sku
- Updating of a Sku
- Deletion of a Sku
- View all Skus
- Recovery of a deleted Sku (additional one-of feature)

## Api

### Sku Object

| Property | Type | Description |
| ------ | ------ | ------ |
| token | string | A unique identifier representing a Sku |
| description | string | A human readable description of the Sku. E.g. Baseball Hat - Red |
| quantity | integer | The current available quantity of a Sku in stock |
| price_cents | integer | The price of a given Sku in CAD |

### View All Skus
Request: `[GET] /inventory/all`
Body:
```
{
    "sku": {
        "token": <optional-unique-token>,
        "description": <description>,
        "quantity": <quantity>,
        "price_cents": <price_cents>
    }
}
```
Returns:
A Sku object matching the one in the request body. If a token was not provided, one will be assigned and provided in the response Sku.

### Create a Sku
Request: `[POST] /inventory/sku`
Body:
```
{
    "sku": {
        "token": <optional-unique-token>,
        "description": <description>,
        "quantity": <quantity>,
        "price_cents": <price_cents>
    }
}
```
Returns:
A Sku object matching the one in the request body. If a token was not provided, one will be assigned and provided in the response Sku.

### Update a Sku
Request: `[PATCH] /inventory/sku`
Body:
```
{
    "sku": {
        "token": <unique-token>,
        "description": <optional-description>,
        "quantity": <optional-quantity>,
        "price_cents": <optional-price_cents>
    }
}
```
Returns:
A complete Sku object that contains the updates provided in the request body.

# Inventory Manager
## Jarod Rankin

This inventory manager application is designed to meet the requirements of the Shopify Backend Intern [job application](https://jobs.smartrecruiters.com/Shopify/743999796499290-backend-developer-intern-summer-2022-remote-us-canada-) requirements.

## Setup Instructions

TBD

## API Features

- Creation of a Sku
- Updating of a Sku
- Deletion of a Sku
- View all Skus
- Recovery of a deleted Sku (additional one-of feature)

## Api

### Sku Object

| Property | Type | Description |
| ------ | ------ | ------ |
| token | string | A unique identifier representing a Sku |
| description | string | A human readable description of the Sku. E.g. Baseball Hat - Red |
| quantity | integer | The current available quantity of a Sku in stock |
| price_cents | integer | The price of a given Sku in CAD |

### Create a Sku
**Request:** `[POST] /inventory/sku`
**Body:**
```
{
    "sku": {
        "token": <optional-unique-token>,
        "description": <description>,
        "quantity": <quantity>,
        "price_cents": <price_cents>
    }
}
```
**Returns:** A Sku object matching the one in the request body. If a token was not provided, one will be assigned and provided in the response Sku.

### Update a Sku
**Request:** `[PATCH] /inventory/sku`
**Body:**
```
{
    "sku": {
        "token": <unique-token>,
        "description": <optional-description>,
        "quantity": <optional-quantity>,
        "price_cents": <optional-price_cents>
    }
}
```
**Returns:** A complete Sku object that contains the updates provided in the request body.

### Delete a Sku
**Request:** `[DELETE] /inventory/sku`
**Body:**
```
{
    "token": <unique-token>,
}
```
**Returns:** An empty response with a `204` status code.

### View all Skus
**Request:** `[GET] /inventory/all`
**Returns:** A Sku object matching the one in the request body. If a token was not provided, one will be assigned and provided in the response Sku.

### Recover a deleted Sku
**Request:** `[POST] /inventory/sku/recover`
**Body:**
```
{
    "token": <unique-token>,
}
```
**Returns:** A Sku object representing the previously deleted (and now recovered) Sku.

### Get a single Sku
**Request:** `[GET] /inventory/sku`
**Body:**
```
{
    "token": <unique-token>,
}
```
**Returns:** A Sku object that has a matching unique token.
