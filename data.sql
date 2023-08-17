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


-- Vets data
INSERT INTO vets (name, age, date_of_graduation) VALUES
    ('William Tatcher', 45, '2000-04-23'),
    ('Maisy Smith', 26, '2019-01-17'),
    ('Stephanie Mendez', 64, '1981-05-04'),
    ('Jack Harkness', 38, '2008-06-08');


-- Specializations data
INSERT INTO specializations (vet_id, species_id)
    SELECT V.id, S.id
    FROM vets V JOIN species S
    ON
        (S.name = 'Pokemon' AND V.name
            IN ('William Tatcher', 'Stephanie Mendez'))
    OR
        (S.name = 'Digimon' AND V.name
            IN ('Stephanie Mendez', 'Jack Harkness'));


-- Visits data
INSERT INTO visits (vet_id, animal_id, visit_date)
SELECT V.id, A.id, to_date(visit_data.visit_date, 'YYYY-MM-DD') AS visit_date
FROM (
    SELECT 'William Tatcher' AS vet_name, 'Agumon' AS animal_name, '2020-05-24' AS visit_date
    UNION ALL
    SELECT 'Stephanie Mendez', 'Agumon', '2020-06-22'
    UNION ALL
    SELECT 'Jack Harkness', 'Gabumon', '2021-02-02'
    UNION ALL
    SELECT 'Maisy Smith', 'Pikachu', '2020-01-05'
    UNION ALL
    SELECT 'Maisy Smith', 'Pikachu', '2020-05-08'
    UNION ALL
    SELECT 'Maisy Smith', 'Pikachu', '2020-05-14'
    UNION ALL
    SELECT 'Stephanie Mendez', 'Devimon', '2021-05-04'
    UNION ALL
    SELECT 'Jack Harkness', 'Charmander', '2021-02-24'
    UNION ALL
    SELECT 'Maisy Smith', 'Plantmon', '2019-12-21'
    UNION ALL
    SELECT 'Maisy Smith', 'Plantmon', '2020-08-10'
    UNION ALL
    SELECT 'Maisy Smith', 'Plantmon', '2021-04-07'
    UNION ALL
    SELECT 'Stephanie Mendez', 'Squirtle', '2019-09-29'
    UNION ALL
    SELECT 'Jack Harkness', 'Angemon', '2020-10-03'
    UNION ALL
    SELECT 'Jack Harkness', 'Angemon', '2020-11-04'
    UNION ALL
    SELECT 'Maisy Smith', 'Boarmon', '2019-01-24'
    UNION ALL
    SELECT 'Maisy Smith', 'Boarmon', '2019-05-15'
    UNION ALL
    SELECT 'Maisy Smith', 'Boarmon', '2020-02-27'
    UNION ALL
    SELECT 'Maisy Smith', 'Boarmon', '2020-08-03'
    UNION ALL
    SELECT 'Stephanie Mendez', 'Blossom', '2020-05-24'
    UNION ALL
    SELECT 'William Tatcher', 'Blossom', '2021-01-11'
) AS visit_data
JOIN vets V ON V.name = visit_data.vet_name
JOIN animals A ON A.name = visit_data.animal_name;

