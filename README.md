# FakeStore API ETL with Pentaho (PDI)

This project implements a complete ETL (Extract, Transform, Load) pipeline using **Pentaho Data Integration (Kettle)**. It extracts e-commerce data from the public [FakeStoreAPI](https://fakestoreapi.com/), transforms the hierarchical JSON structure into relational tables, and loads the data into a local **SQLite** database for downstream analytics.

## 1. Pipeline Overview

The orchestration is managed by the main job **`fakestore_job.kjb`**, which executes the following steps sequentially:

1.  **Environment Setup:** Creates a clean `fakestore.db` file by copying a template (`empty.db`) to the target directory.
2.  **Schema Initialization:** Executes the `create_table.sql` script to build the database structure.
3.  **ETL Execution:** Triggers the **`extract_facts.ktr`** transformation to ingest and process data.
4.  **Analytics Layer:** Executes `create_user_view.sql` to generate analytical views (e.g., user summaries).

## 2. Data Model

The data were arranged in a multidimensional model (star schema).

<p align="center">
  <img src="img/star_schema.png" alt="Star Schema">
</p>

| Table | Type |Description | Key Attributes |
| :--- | :--- | :--- | :--- |
| **`users`** | Dimension table | Customer dimension | `user_id`, `email`, `username`, `firstname`, `lastname`, `city`, `street`, `lat`, `long`. |
| **`products`** | Dimension table |  Product catalog | `product_id`, `title`, `price`, `category`, `description`. |
| **`carts`** | Fact table | A shopping cart associated with a user | `cart_id`, `user_id`. |
| **`cart_items`** | Fact table | The products associated with a shopping cart | `cart_id`, `product_id`, `quantity`. |

## 3. ETL processing (`extract_facts.ktr`)

The ETL processing is made in `extract_facts` transformation, which handles the API consumption and data normalization.

### Data Flow Strategy
1.  **Carts Extraction:** The process begins by fetching all shopping carts from the `https://fakestoreapi.com/carts` endpoint.
2.  **Fact & Dimension Splitting:** Unique User and Product IDs are extracted from carts to dynamically generate  API URLs.
3.  **Enrichment:** The pipeline performs HTTP GET requests for every unique User and Product to fetch full details (Name, Address, Geo-coordinates, Product Category, etc.).
4.  **Loading:** Data is inserted into the SQLite database.
   
    *Note:* The pipeline handles duplicate handling using logic such as `INSERT OR IGNORE` for the `carts` table.

## 4. Getting Started

### Prerequisites
* **Java Runtime Environment (JRE)** 8 or higher.
* **Pentaho Data Integration (Spoon)** 8.0 or higher.

### Directory Structure
To ensure the relative paths (`${Internal.Entry.Current.Directory}`) work correctly, maintain this folder structure:

```text
/project-root
├── fakestore_job.kjb        # Main Job Entry Point
├── extract_facts.ktr        # ETL Transformation
├── db/
│   ├── empty.db             # Empty SQLite template (Required)
│   └── fakestore.db         # Output database (Generated automatically)
└── sql/
    ├── create_table.sql     # DDL Script (Required)
    └── create_user_view.sql # Analytics View Script (Required)
