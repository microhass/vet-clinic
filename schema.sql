CREATE DATABASE vet_clinic;

-- \c vet_clinic

CREATE TABLE animals (
  id    INT GENERATED ALWAYS AS IDENTITY,
  name  VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  escape_attempts   INT,
  neutered  BIT,
  weight_kg FLOAT,
  PRIMARY KEY (id)
);

ALTER TABLE animals ADD COLUMN species varchar(100);


-- Create owners table
CREATE TABLE owners (
  id  INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(100),
  age INT,
  PRIMARY KEY (id)
);


-- Create species table
CREATE TABLE species (
  id  INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  PRIMARY KEY (id)
);


-- Remove species col in animals
ALTER TABLE animals DROP COLUMN species;

-- Add col species-id to animals
ALTER TABLE animals ADD COLUMN species_id INT;

-- Make species-id foreign key
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id);

-- Add col owner-id to animals
ALTER TABLE animals ADD COLUMN owner_id INT;

-- Make owner-id foreign key
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY(owner_id) REFERENCES owners(id);
