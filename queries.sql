SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2015-12-31' AND '2020-01-01';
SELECT name FROM animals WHERE neutered = '1' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = '1';
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Unspecified species
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


-- Set species
BEGIN;
UPDATE animals
SET species = 'digmon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species = '';

SELECT * FROM animals;
COMMIT;

SELECT * FROM animals;


-- Deep breath ;)
-- Test delete all animals
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;


-- Weights update
BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT del_young_ones;

UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO del_young_ones;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;


-- Aggregates
-- How many animals are there?
SELECT COUNT(*) AS total_animals FROM animals;

-- How many have not tried to escape
SELECT COUNT(*) AS not_escaped FROM animals
WHERE escape_attempts = '0';

-- Average animals weight?
SELECT AVG(weight_kg) AS avg_weight FROM animals;

-- Neutered or not, who escapes the most?
SELECT
    neutered,
    AVG(escape_attempts) AS avg_escapes
    FROM animals
GROUP BY neutered
ORDER BY avg_escapes DESC;

-- Min & max weight for each type of animal?
SELECT
    species,
    MIN(weight_kg) AS min_weight_kg,
    MAX(weight_kg) AS max_weight_kg
    FROM animals
GROUP BY species;

-- Avg escape attempts per animal type born between 1990 & 2000?
SELECT
    species,
    AVG(escape_attempts) AS avg_escapes
    FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01'
GROUP BY species;
