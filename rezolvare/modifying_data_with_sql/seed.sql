USE cinema_db;

INSERT INTO movies (title, genre, year_released, director, rating, ticket_price, seats_sold) VALUES
    ('The Matrix',          'Sci-Fi',   1999, 'Wachowskis',         8.7, 25.00, 320),
    ('The Matrix Reloaded', 'Sci-Fi',   2003, 'Wachowskis',         7.2, 25.00, 250),
    ('Inception',           'Sci-Fi',   2010, 'Christopher Nolan',  8.8, 30.00, 410),
    ('Interstellar',        'Sci-Fi',   2014, 'Christopher Nolan',  8.6, 30.00, 380),
    ('The Godfather',       'Drama',    1972, 'Francis F. Coppola', 9.2, 22.00, 180),
    ('Pulp Fiction',        'Crime',    1994, 'Quentin Tarantino',  8.9, 25.00, 290),
    ('Forrest Gump',        'Drama',    1994, 'Robert Zemeckis',    8.8, 22.00, 260),
    ('Titanic',             'Romance',  1997, 'James Cameron',      7.9, 28.00, 510),
    ('Avatar',              'Sci-Fi',   2009, 'James Cameron',      7.8, 30.00, 600),
    ('The Dark Knight',     'Action',   2008, 'Christopher Nolan',  9.0, 30.00, 480);
