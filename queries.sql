SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';
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


-- Multiple tables queries
-- Animals that belong to Melody Pond
SELECT A.id, A.name FROM animals A
    INNER JOIN owners O
    ON A.owner_id = O.id
    WHERE O.full_name = 'Melody Pond';


-- Animals of type pokemon
SELECT A.id, A.name, A.owner_id FROM animals A
    INNER JOIN species S
    ON A.species_id = S.id
    WHERE S.name = 'Pokemon';


-- All owners & their animals
SELECT O.id, O.full_name AS owner, A.name AS animal FROM owners O
    LEFT JOIN animals A
    ON O.id = A.owner_id;


-- Num of animals per species
SELECT S.name AS species, COUNT(A.name) AS species_count FROM animals A
    RIGHT JOIN species S
    ON A.species_id = S.id
    GROUP BY S.name
    ORDER BY species_count DESC;


-- All digimon owned by Jennifer
SELECT
    A.id AS animal_id,
    A.name AS animal_name,
    S.name AS species_name,
    O.full_name AS owner_name
    FROM animals A
JOIN owners O
ON O.id = A.owner_id
INNER JOIN species S
ON S.id = A.species_id
WHERE S.name = 'Digimon' AND O.full_name = 'Jennifer Orwell';


-- Animals by Dean that haven't tried to escape
SELECT
    A.id AS animal_id,
    A.name AS animal_name,
    O.full_name AS owner_name
    FROM animals A
INNER JOIN owners O
ON A.owner_id = O.id
WHERE A.escape_attempts = 0 AND O.full_name = 'Dean Winchester';


-- Owner of most animals
SELECT O.full_name AS owner_name, COUNT(A.name) AS no_of_animals FROM animals A
    LEFT JOIN owners O
    ON A.owner_id = O.id
    GROUP BY owner_name
    ORDER BY no_of_animals DESC;


-- Join tables queries
-- The last animal seen by William Tatcher?
SELECT
    A.name AS animal_name,
    MAX(Vi.visit_date) AS latest_visit
    FROM visits Vi
INNER JOIN vets Ve
    ON Vi.vet_id = Ve.id
INNER JOIN animals A
    ON A.id = Vi.animal_id
WHERE Ve.name = 'William Tatcher'
GROUP BY animal_name
ORDER BY latest_visit DESC
LIMIT 1;


-- How many different animals did Stephanie Mendez see?
SELECT DISTINCT COUNT(A.name) AS animal_count FROM animals A
    INNER JOIN visits Vi
        ON Vi.animal_id = A.id
    INNER JOIN vets Ve
        ON Ve.id = Vi.vet_id
WHERE Ve.name = 'Stephanie Mendez';


-- All vets and their specialties, including vets with no specialties.
SELECT Ve.name AS vet, Sp.name AS specialty
    FROM specializations S
RIGHT JOIN vets Ve
    ON Ve.id = S.vet_id
LEFT JOIN species Sp
    ON Sp.id = S.species_id;


-- All animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT DISTINCT A.name AS animal, Vi.visit_date FROM animals A
    INNER JOIN visits Vi
        ON Vi.animal_id = A.id
    INNER JOIN vets Ve
        ON Ve.id = Vi.vet_id
WHERE Ve.name = 'Stephanie Mendez'
AND Vi.visit_date BETWEEN '2020-04-01' AND '2020-08-30';


-- Animal with the most visits to vets?
SELECT
    A.id as animal_id,
    A.name AS animal,
    COUNT(Vi.animal_id) AS no_of_visits
    FROM animals A
INNER JOIN visits Vi
    ON Vi.animal_id = A.id
GROUP BY animal, A.id
ORDER BY no_of_visits DESC;


-- Maisy Smith's first visit?
SELECT
    A.name AS animal,
    MIN(Vi.visit_date) AS visit_date
    FROM animals A
INNER JOIN visits Vi
    ON Vi.animal_id = A.id
INNER JOIN vets Ve
    ON Ve.id = Vi.vet_id
WHERE Ve.name = 'Maisy Smith'
GROUP BY A.name
ORDER BY visit_date ASC
LIMIT 1;


-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
    A.id AS animal_id,
    A.name AS animal,
    Ve.id AS vet_id,
    Ve.name AS vet,
    MAX(Vi.visit_date) AS visit_date
    FROM animals A
INNER JOIN visits Vi
    ON Vi.animal_id = A.id
INNER JOIN vets Ve
    ON Ve.id = Vi.vet_id
GROUP BY A.name, Ve.name, A.id, Ve.id
ORDER BY visit_date DESC
LIMIT 1;


-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS non_spec_visits FROM visits Vi
    INNER JOIN animals A
        ON A.id = Vi.animal_id
    INNER JOIN vets Ve
        ON Vi.vet_id = Ve.id
    LEFT JOIN specializations Sp
        ON Sp.vet_id = Ve.id AND A.species_id = Sp.species_id
WHERE Sp.vet_id IS NULL;


-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT S.name AS Maisy_species_consideration FROM species S
    INNER JOIN animals A ON S.id = A.species_id
    INNER JOIN visits Vi ON A.id = Vi.animal_id
    INNER JOIN vets Ve ON Vi.vet_id = Ve.id
WHERE Ve.name = 'Maisy Smith'
GROUP BY S.name
ORDER BY COUNT(Vi.visit_date) DESC
LIMIT 1;
