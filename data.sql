INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES
    ('Agumon', '2020-2-3', 10.23, '1', 0),
    ('Gabumon', '2018-11-15', 8.0, '1', 2),
    ('Pikachu', '2021-1-7', 15.04, '0', 1),
    ('Devimon', '2017-5-12', 11, '1', 5);


INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES
    ('Charmander', '2020-2-8', 11.0, '0', 0),
    ('Plantmon', '2021-11-15', 5.7, '1', 2),
    ('Squirtle', '1993-4-2', 12.13, '0', 3),
    ('Angemon', '2005-6-12', 45.0, '1', 1),
    ('Boarmon', '2005-6-7', 20.4, '1', 7),
    ('Blossom', '1998-10-13', 17.0, '1', 3),
    ('Ditto', '2022-5-14', 22.0, '1', 4);


INSERT INTO owners (full_name, age) VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);


INSERT INTO species (name) VALUES
    ('Pokemon'),
    ('Digimon');


-- Link animals to species
BEGIN;
UPDATE animals
SET species_id = 2
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = 1
WHERE species_id IS NULL;
COMMIT;


-- Link animals to owners
UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';
UPDATE animals SET owner_id = 2 WHERE name IN ('Gabumon', 'Pikachu');
UPDATE animals SET owner_id = 3 WHERE name IN ('Devimon', 'Plantmon');
UPDATE animals SET owner_id = 4 WHERE name IN ('Charmander', 'Squirtle', 'Blossom');
UPDATE animals SET owner_id = 5 WHERE name IN ('Angemon', 'Boarmon');

