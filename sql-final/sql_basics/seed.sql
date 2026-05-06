USE library_db;

INSERT INTO books (title, author, genre, year_published, pages, price, in_stock, rating) VALUES
    ('Clean Code',                       'Robert C. Martin',     'Programming', 2008,  464, 149.00, TRUE,  4.40),
    ('The Pragmatic Programmer',         'Andrew Hunt',          'Programming', 1999,  320, 139.00, TRUE,  4.30),
    ('Designing Data-Intensive Apps',    'Martin Kleppmann',     'Programming', 2017,  616, 189.00, TRUE,  4.70),
    ('Eloquent JavaScript',              'Marijn Haverbeke',     'Programming', 2018,  472, 119.00, FALSE, 4.10),
    ('You Don''t Know JS',               'Kyle Simpson',         'Programming', 2015,  278,  99.00, TRUE,  4.20),
    ('1984',                             'George Orwell',        'Fiction',     1949,  328,  39.99, TRUE,  4.50),
    ('Brave New World',                  'Aldous Huxley',        'Fiction',     1932,  311,  35.00, TRUE,  4.00),
    ('To Kill a Mockingbird',            'Harper Lee',           'Fiction',     1960,  281,  42.50, TRUE,  4.60),
    ('The Great Gatsby',                 'F. Scott Fitzgerald',  'Fiction',     1925,  180,  29.00, FALSE, 3.90),
    ('A Brief History of Time',          'Stephen Hawking',      'Science',     1988,  256,  79.00, TRUE,  4.30),
    ('Cosmos',                           'Carl Sagan',           'Science',     1980,  396,  89.00, TRUE,  4.50),
    ('Sapiens',                          'Yuval Noah Harari',    'History',     2011,  464,  99.99, TRUE,  4.40),
    ('Homo Deus',                        'Yuval Noah Harari',    'History',     2016,  464, 109.00, TRUE,  4.20),
    ('The Art of War',                   'Sun Tzu',              'History',     -500, NULL,  19.99, TRUE,  3.80),
    ('Becoming',                         'Michelle Obama',       'Biography',   2018,  448,  89.00, FALSE, NULL),
    ('Steve Jobs',                       'Walter Isaacson',      'Biography',   2011,  656, 109.00, TRUE,  4.10),
    ('Elon Musk',                        'Walter Isaacson',      'Biography',   2023,  688, 129.00, TRUE,  3.70),
    ('The Hobbit',                       'J. R. R. Tolkien',     'Fantasy',     1937,  310,  49.00, TRUE,  4.70),
    ('Harry Potter and the Goblet of Fire','J. K. Rowling',      'Fantasy',     2000,  734,  69.00, TRUE,  4.60),
    ('Mistborn',                         'Brandon Sanderson',    'Fantasy',     2006,  541,  59.00, TRUE,  NULL);
