-- =============================================
-- BREWERY & COFFEE SHOP FINDER DATABASE - QUEBEC
-- =============================================
-- A unique database for discovering local breweries and coffee shops in Quebec
-- Features locations in Montreal and Laval with French-Canadian flair

-- Drop database if exists and create new one
DROP DATABASE IF EXISTS brew_finder;
CREATE DATABASE brew_finder CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE brew_finder;

-- =============================================
-- CUSTOMERS TABLE
-- =============================================
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    favorite_drink_type ENUM('coffee', 'tea', 'beer', 'cocktail', 'other') DEFAULT 'coffee',
    loyalty_points INT DEFAULT 0,
    join_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- CAFES TABLE (Coffee Shops)
-- =============================================
CREATE TABLE cafes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    instagram_handle VARCHAR(50),
    opening_time TIME NOT NULL, 
    closing_time TIME NOT NULL,
    wifi_available BOOLEAN DEFAULT TRUE,
    outdoor_seating BOOLEAN DEFAULT FALSE,
    pet_friendly BOOLEAN DEFAULT FALSE,
    parking_available BOOLEAN DEFAULT TRUE,
    roasts_own_beans BOOLEAN DEFAULT FALSE,
    specialty VARCHAR(100), -- e.g., "Single Origin", "Cold Brew", "Latte Art"
    atmosphere ENUM('cozy', 'modern', 'rustic', 'hipster', 'corporate', 'artsy') DEFAULT 'cozy',
    price_range ENUM('$', '$$', '$$$', '$$$$') DEFAULT '$$',
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city (city),
    INDEX idx_rating (average_rating),
    INDEX idx_specialty (specialty)
);

-- =============================================
-- BREWERIES TABLE
-- =============================================
CREATE TABLE breweries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    instagram_handle VARCHAR(50),
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    brewery_type ENUM('microbrewery', 'brewpub', 'taproom', 'regional', 'contract') DEFAULT 'microbrewery',
    established_year YEAR,
    outdoor_seating BOOLEAN DEFAULT FALSE,
    food_available BOOLEAN DEFAULT FALSE,
    tours_available BOOLEAN DEFAULT FALSE,
    pet_friendly BOOLEAN DEFAULT FALSE,
    parking_available BOOLEAN DEFAULT TRUE,
    signature_beer VARCHAR(100),
    beer_styles VARCHAR(200), -- e.g., "IPA, Stout, Lager"
    atmosphere ENUM('casual', 'upscale', 'industrial', 'family-friendly', 'trendy') DEFAULT 'casual',
    price_range ENUM('$', '$$', '$$$', '$$$$') DEFAULT '$$',
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_city (city),
    INDEX idx_type (brewery_type),
    INDEX idx_rating (average_rating)
);

-- =============================================
-- DRINKS TABLE
-- =============================================
CREATE TABLE drinks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category ENUM('coffee', 'tea', 'beer', 'cocktail', 'non-alcoholic', 'pastry') NOT NULL,
    subcategory VARCHAR(50), -- e.g., "IPA", "Espresso", "Green Tea", "Cocktail"
    price DECIMAL(5,2) NOT NULL,
    alcohol_content DECIMAL(4,2) DEFAULT NULL, -- For beers/cocktails
    caffeine_content VARCHAR(20) DEFAULT NULL, -- e.g., "High", "Medium", "None"
    size VARCHAR(20) DEFAULT 'Regular', -- e.g., "Small", "Regular", "Large", "Pint"
    calories INT DEFAULT NULL,
    ingredients TEXT,
    allergens VARCHAR(100), -- e.g., "Milk, Nuts, Gluten"
    vegan BOOLEAN DEFAULT FALSE,
    gluten_free BOOLEAN DEFAULT FALSE,
    seasonal BOOLEAN DEFAULT FALSE,
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_price (price),
    INDEX idx_available (available)
);

-- =============================================
-- CAFE_DRINKS TABLE (What drinks each cafe offers)
-- =============================================
CREATE TABLE cafe_drinks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cafe_id INT NOT NULL,
    drink_id INT NOT NULL,
    is_signature BOOLEAN DEFAULT FALSE,
    daily_special_day ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') DEFAULT NULL,
    added_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (cafe_id) REFERENCES cafes(id) ON DELETE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES drinks(id) ON DELETE CASCADE,
    UNIQUE KEY unique_cafe_drink (cafe_id, drink_id)
);

-- =============================================
-- BREWERY_DRINKS TABLE (What drinks each brewery offers)
-- =============================================
CREATE TABLE brewery_drinks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brewery_id INT NOT NULL,
    drink_id INT NOT NULL,
    is_flagship BOOLEAN DEFAULT FALSE,
    seasonal_availability VARCHAR(50) DEFAULT NULL, -- e.g., "Summer", "Winter", "Year-round"
    abv DECIMAL(4,2) DEFAULT NULL, -- Alcohol by volume
    ibu INT DEFAULT NULL, -- International Bitterness Units for beer
    added_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (brewery_id) REFERENCES breweries(id) ON DELETE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES drinks(id) ON DELETE CASCADE,
    UNIQUE KEY unique_brewery_drink (brewery_id, drink_id)
);

-- =============================================
-- REVIEWS TABLE
-- =============================================
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    location_type ENUM('cafe', 'brewery') NOT NULL,
    location_id INT NOT NULL, -- References either cafes.id or breweries.id
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    visited_date DATE DEFAULT (CURRENT_DATE),
    drink_ordered VARCHAR(100), -- What they ordered
    service_rating INT DEFAULT NULL CHECK (service_rating >= 1 AND service_rating <= 5),
    atmosphere_rating INT DEFAULT NULL CHECK (atmosphere_rating >= 1 AND atmosphere_rating <= 5),
    value_rating INT DEFAULT NULL CHECK (value_rating >= 1 AND value_rating <= 5),
    would_recommend BOOLEAN DEFAULT TRUE,
    photo_url VARCHAR(255) DEFAULT NULL,
    helpful_votes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    INDEX idx_location (location_type, location_id),
    INDEX idx_rating (rating),
    INDEX idx_customer (customer_id)
);

-- =============================================
-- EVENTS TABLE (Special events at locations)
-- =============================================
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location_type ENUM('cafe', 'brewery') NOT NULL,
    location_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    event_type ENUM('live_music', 'trivia', 'tasting', 'workshop', 'art_show', 'open_mic', 'other') NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME,
    price DECIMAL(6,2) DEFAULT 0.00,
    max_attendees INT DEFAULT NULL,
    requires_reservation BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_event_date (event_date),
    INDEX idx_location (location_type, location_id)
);

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Insert Customers
INSERT INTO customers (first_name, last_name, email, phone, date_of_birth, favorite_drink_type, loyalty_points, join_date) VALUES
('Émilie', 'Dubois', 'emilie.dubois@email.com', '514-555-0101', '1992-03-15', 'coffee', 245, '2023-06-15'),
('Marc', 'Tremblay', 'marc.tremblay@email.com', '514-555-0102', '1988-07-22', 'beer', 380, '2023-04-20'),
('Sophie', 'Gagnon', 'sophie.gagnon@email.com', '514-555-0103', '1995-11-08', 'tea', 120, '2023-08-10'),
('Jean', 'Leblanc', 'jean.leblanc@email.com', '450-555-0104', '1990-01-30', 'coffee', 89, '2023-09-05'),
('Amélie', 'Bouchard', 'amelie.bouchard@email.com', '514-555-0105', '1993-05-17', 'cocktail', 156, '2023-07-12'),
('Alexandre', 'Roy', 'alexandre.roy@email.com', '450-555-0106', '1987-12-03', 'beer', 420, '2023-03-08'),
('Isabelle', 'Martin', 'isabelle.martin@email.com', '514-555-0107', '1996-09-25', 'coffee', 78, '2023-10-01'),
('David', 'Lavoie', 'david.lavoie@email.com', '450-555-0108', '1985-04-12', 'beer', 290, '2023-05-18'),
('Catherine', 'Beaulieu', 'catherine.beaulieu@email.com', '418-555-0109', '1991-02-28', 'tea', 167, '2023-06-22'),
('Philippe', 'Côté', 'philippe.cote@email.com', '819-555-0110', '1989-08-14', 'coffee', 203, '2023-05-30'),
('Marie-Claude', 'Pelletier', 'mc.pelletier@email.com', '514-555-0111', '1994-12-11', 'beer', 98, '2023-09-18'),
('Vincent', 'Morin', 'vincent.morin@email.com', '450-555-0112', '1986-06-07', 'coffee', 345, '2023-03-25'),
('Julie', 'Fortin', 'julie.fortin@email.com', '418-555-0113', '1993-04-19', 'cocktail', 88, '2023-08-08'),
('Patrick', 'Bélanger', 'patrick.belanger@email.com', '819-555-0114', '1987-10-02', 'beer', 412, '2023-04-15'),
('Nathalie', 'Girard', 'nathalie.girard@email.com', '514-555-0115', '1992-07-24', 'tea', 134, '2023-07-03'),
('François', 'Bergeron', 'francois.bergeron@email.com', '418-555-0116', '1990-11-16', 'coffee', 276, '2023-06-10'),
('Stéphanie', 'Lévesque', 'stephanie.levesque@email.com', '450-555-0117', '1995-01-08', 'other', 65, '2023-09-12'),
('Benoit', 'Simard', 'benoit.simard@email.com', '819-555-0118', '1984-03-21', 'beer', 198, '2023-05-07'),
('Manon', 'Rousseau', 'manon.rousseau@email.com', '514-555-0119', '1991-09-13', 'coffee', 156, '2023-08-20'),
('Christian', 'Gauthier', 'christian.gauthier@email.com', '418-555-0120', '1988-05-29', 'beer', 322, '2023-04-02');

-- Insert Cafes
INSERT INTO cafes (name, description, address, city, state, zip_code, phone, email, website, instagram_handle, opening_time, closing_time, wifi_available, outdoor_seating, pet_friendly, roasts_own_beans, specialty, atmosphere, price_range, average_rating, total_reviews) VALUES
-- Montreal cafes
('Café des Artisans', 'Cozy neighborhood coffee shop with house-roasted beans', '1234 Rue Saint-Denis', 'Montreal', 'QC', 'H2X 3K3', '514-555-0201', 'bonjour@cafedesartisans.ca', 'www.cafedesartisans.ca', '@cafedesartisans', '06:00:00', '20:00:00', TRUE, TRUE, TRUE, TRUE, 'Single Origin', 'cozy', '$$', 4.5, 87),
('Le Grind Quotidien', 'Modern coffee house perfect for remote work', '456 Boulevard Saint-Laurent', 'Montreal', 'QC', 'H2Y 2Y5', '514-555-0202', 'info@legrind.ca', 'www.legrindquotidien.ca', '@legrindmtl', '05:30:00', '22:00:00', TRUE, FALSE, FALSE, FALSE, 'Cold Brew', 'modern', '$$$', 4.2, 134),
('Torréfacteurs du Plateau', 'Small batch roastery with exceptional espresso', '789 Avenue du Mont-Royal', 'Montreal', 'QC', 'H2J 1X6', '514-555-0203', 'contact@torrefacteursplateau.ca', 'www.torrefacteursplateau.ca', '@torrefacteursplateau', '07:00:00', '18:00:00', TRUE, TRUE, TRUE, TRUE, 'Latte Art', 'artsy', '$$$', 4.7, 156),
('Café du Coin', 'Friendly local spot with homemade pastries', '321 Rue Sainte-Catherine', 'Montreal', 'QC', 'H3B 1A6', '514-555-0204', 'bonjour@cafecoin.ca', 'www.cafeducoincafe.ca', '@cafeducoincafe', '06:30:00', '19:00:00', TRUE, TRUE, TRUE, FALSE, 'Pastries', 'cozy', '$', 4.3, 92),
-- Laval cafes
('Café Vitesse', 'High-energy spot for coffee enthusiasts', '654 Boulevard des Laurentides', 'Laval', 'QC', 'H7G 2T8', '450-555-0205', 'info@cafevitesse.ca', 'www.cafevitesse.ca', '@cafevitesselaval', '05:00:00', '21:00:00', TRUE, FALSE, FALSE, TRUE, 'Espresso', 'modern', '$$', 4.4, 203),
('Café des Îles', 'Relaxing island-themed coffee house', '987 Rue de la Concorde', 'Laval', 'QC', 'H7N 5B6', '450-555-0206', 'info@cafedesiles.ca', 'www.cafedesiles.ca', '@cafedesiles', '06:00:00', '20:00:00', TRUE, TRUE, TRUE, FALSE, 'Tropical Blends', 'cozy', '$$', 4.1, 78),
-- Quebec City cafes
('Café du Château', 'Historic cafe near Old Quebec with French charm', '234 Rue Saint-Jean', 'Quebec City', 'QC', 'G1R 1P8', '418-555-0207', 'bonjour@cafechateau.ca', 'www.cafeduchateau.ca', '@cafechateau', '07:00:00', '19:00:00', TRUE, TRUE, FALSE, TRUE, 'French Roast', 'rustic', '$$$', 4.6, 145),
('Le Petit Torréfacteur', 'Artisanal coffee roastery in Vieux-Québec', '567 Grande Allée', 'Quebec City', 'QC', 'G1S 1C1', '418-555-0208', 'contact@petittorrefacteur.ca', 'www.petittorrefacteur.ca', '@petittorre', '06:30:00', '18:30:00', TRUE, FALSE, TRUE, TRUE, 'Artisanal Roasts', 'artsy', '$$$', 4.8, 203),
('Café des Plaines', 'Modern cafe with view of Plains of Abraham', '890 Chemin Sainte-Foy', 'Quebec City', 'QC', 'G1S 2L2', '418-555-0209', 'info@cafeplaines.ca', 'www.cafedesplaines.ca', '@cafeplaines', '06:00:00', '21:00:00', TRUE, TRUE, TRUE, FALSE, 'Organic Blends', 'modern', '$$', 4.3, 112),
-- Sherbrooke cafes
('Café Universitaire', 'Student-friendly cafe near campus', '123 Rue King', 'Sherbrooke', 'QC', 'J1H 1N4', '819-555-0210', 'info@cafeuniversitaire.ca', 'www.cafeuniversitaire.ca', '@cafeuni', '05:30:00', '23:00:00', TRUE, FALSE, FALSE, FALSE, 'Study Blends', 'modern', '$', 4.0, 189),
('Torréfaction Estrie', 'Eastern Townships roastery with local beans', '456 Rue Wellington', 'Sherbrooke', 'QC', 'J1H 5C7', '819-555-0211', 'bonjour@torrefactionestrie.ca', 'www.torrefactionestrie.ca', '@torrefestrie', '07:00:00', '17:00:00', TRUE, TRUE, TRUE, TRUE, 'Local Beans', 'rustic', '$$', 4.5, 98),
-- Trois-Rivières cafes
('Café Mauricie', 'Cozy cafe celebrating the Mauricie region', '789 Rue des Forges', 'Trois-Rivières', 'QC', 'G9A 2G8', '819-555-0212', 'info@cafemauricie.ca', 'www.cafemauricie.ca', '@cafemauricie', '06:00:00', '19:00:00', TRUE, TRUE, TRUE, FALSE, 'Regional Specialty', 'cozy', '$$', 4.2, 67),
-- Gatineau cafes
('Café Outaouais', 'Bilingual cafe serving the capital region', '321 Boulevard Saint-Joseph', 'Gatineau', 'QC', 'J8Y 3Y2', '819-555-0213', 'hello@cafeoutaouais.ca', 'www.cafeoutaouais.ca', '@cafeoutaouais', '06:30:00', '20:00:00', TRUE, FALSE, TRUE, FALSE, 'Bilingual Blends', 'corporate', '$$', 4.1, 134),
-- Chicoutimi cafes
('Café du Fjord', 'Scenic cafe overlooking the Saguenay Fjord', '654 Rue Racine', 'Chicoutimi', 'QC', 'G7H 1V4', '418-555-0214', 'info@cafefjord.ca', 'www.cafedufjord.ca', '@cafefjord', '07:00:00', '18:00:00', TRUE, TRUE, TRUE, TRUE, 'Mountain Blends', 'rustic', '$$$', 4.4, 89);

-- Insert Breweries
INSERT INTO breweries (name, description, address, city, state, zip_code, phone, email, website, instagram_handle, opening_time, closing_time, brewery_type, established_year, outdoor_seating, food_available, tours_available, pet_friendly, signature_beer, beer_styles, atmosphere, price_range, average_rating, total_reviews) VALUES
-- Montreal breweries
('Brasserie du Houblon', 'Craft brewery specializing in hoppy IPAs and rich stouts', '888 Rue Notre-Dame', 'Montreal', 'QC', 'H3C 1K3', '514-555-0301', 'info@brasseriehoublon.ca', 'www.brasseriehoublon.ca', '@brasseriehoublon', '12:00:00', '22:00:00', 'microbrewery', 2015, TRUE, TRUE, TRUE, TRUE, 'IPA Québécoise', 'IPA, Stout, Pale Ale', 'casual', '$$', 4.6, 178),
('Taverne Industrielle', 'Industrial-style taproom with rotating selection', '999 Rue Rachel', 'Montreal', 'QC', 'H2J 2J8', '514-555-0302', 'bonjour@taverneindustrielle.ca', 'www.taverneindustrielle.ca', '@taverneindust', '15:00:00', '23:00:00', 'taproom', 2018, FALSE, FALSE, FALSE, FALSE, 'Lager Vapeur', 'Lager, Wheat, Sour', 'industrial', '$$$', 4.3, 95),
('Brasseurs du Plateau', 'Montreal brewery with innovative flavors', '777 Avenue Papineau', 'Montreal', 'QC', 'H2K 4J5', '514-555-0303', 'contact@brasseursplateau.ca', 'www.brasseursplateau.ca', '@brasseursplateau', '14:00:00', '21:00:00', 'brewpub', 2012, TRUE, TRUE, TRUE, TRUE, 'Montréal Rêveur IPA', 'IPA, Pilsner, Saison', 'trendy', '$$$', 4.5, 142),
-- Laval breweries
('Microbrasserie des Îles', 'Quebec-style brewery with big flavors', '555 Boulevard Saint-Martin', 'Laval', 'QC', 'H7T 1B3', '450-555-0304', 'info@microbrasserieiles.ca', 'www.microbrasseriedesiles.ca', '@microiles', '11:00:00', '24:00:00', 'regional', 2008, TRUE, TRUE, FALSE, TRUE, 'Tonnerre des Îles IPA', 'IPA, Porter, Wheat', 'family-friendly', '$$', 4.4, 267),
('Brasserie Laurentienne', 'Local brewery with natural mountain water', '432 Chemin du Souvenir', 'Laval', 'QC', 'H7W 1A3', '450-555-0305', 'bonjour@brasserielaurentienne.ca', 'www.brasserielaurentienne.ca', '@brasslaurentienne', '13:00:00', '22:00:00', 'microbrewery', 2017, TRUE, TRUE, TRUE, TRUE, 'Ale des Laurentides', 'IPA, Stout, Amber', 'casual', '$$', 4.7, 89),
-- Quebec City breweries
('Brasserie de la Capitale', 'Historic brewery in the heart of Old Quebec', '345 Rue Saint-Paul', 'Quebec City', 'QC', 'G1K 3X2', '418-555-0306', 'info@brasseriecapitale.ca', 'www.brasseriecapitale.ca', '@brasscapitale', '11:00:00', '23:00:00', 'brewpub', 2010, TRUE, TRUE, TRUE, FALSE, 'Château Ale', 'Ale, Wheat, Belgian', 'upscale', '$$$', 4.8, 198),
('Microbrasserie des Remparts', 'Artisanal brewery with Quebec City heritage', '678 Grande Allée Est', 'Quebec City', 'QC', 'G1R 2K5', '418-555-0307', 'contact@brasserieremparts.ca', 'www.brasserieremparts.ca', '@brassremparts', '12:00:00', '22:00:00', 'microbrewery', 2014, FALSE, TRUE, TRUE, TRUE, 'Rempart Rouge', 'Red Ale, IPA, Porter', 'casual', '$$', 4.5, 156),
-- Sherbrooke breweries
('Brasserie des Cantons', 'Eastern Townships brewery with local ingredients', '234 Rue King Ouest', 'Sherbrooke', 'QC', 'J1H 1P4', '819-555-0308', 'info@brasseriecantons.ca', 'www.brasseriecantons.ca', '@brasscantons', '15:00:00', '21:00:00', 'regional', 2016, TRUE, TRUE, FALSE, TRUE, 'Estrie IPA', 'IPA, Lager, Seasonal', 'family-friendly', '$$', 4.3, 123),
-- Trois-Rivières breweries
('Microbrasserie Mauricie', 'Celebrating the heritage of the Mauricie region', '567 Rue des Forges', 'Trois-Rivières', 'QC', 'G9A 2G9', '819-555-0309', 'bonjour@micromauricie.ca', 'www.micromauricie.ca', '@micromauricie', '14:00:00', '22:00:00', 'microbrewery', 2013, TRUE, FALSE, TRUE, FALSE, 'Trifluvienne Blonde', 'Blonde, Stout, Saison', 'casual', '$$', 4.2, 87),
-- Gatineau breweries
('Brasserie de la Capitale-Nationale', 'Bilingual brewery serving Ottawa-Gatineau region', '890 Boulevard Maloney', 'Gatineau', 'QC', 'J8T 3R6', '819-555-0310', 'hello@brasscapnat.ca', 'www.brasscapnat.ca', '@brasscapnat', '16:00:00', '23:00:00', 'taproom', 2019, FALSE, FALSE, FALSE, TRUE, 'Outaouais Amber', 'Amber, Wheat, IPA', 'trendy', '$$$', 4.1, 76),
-- Chicoutimi breweries
('Brasserie du Fjord', 'Mountain brewery with Saguenay Fjord inspiration', '123 Rue Racine Est', 'Chicoutimi', 'QC', 'G7H 1R8', '418-555-0311', 'info@brasseriefjord.ca', 'www.brasseriefjord.ca', '@brassfjord', '13:00:00', '21:00:00', 'microbrewery', 2011, TRUE, TRUE, TRUE, TRUE, 'Fjord Noir', 'Porter, IPA, Wheat', 'casual', '$$', 4.6, 134);

-- Insert Drinks
INSERT INTO drinks (name, description, category, subcategory, price, alcohol_content, caffeine_content, size, calories, vegan, gluten_free, seasonal) VALUES
-- Coffee Drinks
('Espresso', 'Rich, concentrated coffee shot', 'coffee', 'Espresso', 2.50, NULL, 'High', 'Single', 5, TRUE, TRUE, FALSE),
('Cappuccino', 'Espresso with steamed milk and foam', 'coffee', 'Espresso', 4.25, NULL, 'Medium', 'Regular', 120, FALSE, TRUE, FALSE),
('Latte', 'Espresso with steamed milk', 'coffee', 'Latte', 4.50, NULL, 'Medium', 'Regular', 150, FALSE, TRUE, FALSE),
('Americano', 'Espresso with hot water', 'coffee', 'Espresso', 3.25, NULL, 'High', 'Regular', 10, TRUE, TRUE, FALSE),
('Mocha', 'Espresso with chocolate and steamed milk', 'coffee', 'Latte', 5.25, NULL, 'Medium', 'Regular', 290, FALSE, TRUE, FALSE),
('Cold Brew', 'Smooth, cold-steeped coffee', 'coffee', 'Cold Brew', 3.75, NULL, 'High', 'Regular', 15, TRUE, TRUE, FALSE),
('Pumpkin Spice Latte', 'Seasonal autumn favorite', 'coffee', 'Latte', 5.50, NULL, 'Medium', 'Large', 280, FALSE, TRUE, TRUE),
('Nitro Cold Brew', 'Cold brew infused with nitrogen', 'coffee', 'Cold Brew', 4.50, NULL, 'High', 'Regular', 20, TRUE, TRUE, FALSE),
('Maple Latte', 'Canadian maple syrup latte', 'coffee', 'Latte', 5.00, NULL, 'Medium', 'Regular', 200, FALSE, TRUE, TRUE),
('French Press', 'Traditional brewing method coffee', 'coffee', 'French Press', 4.00, NULL, 'High', 'Regular', 12, TRUE, TRUE, FALSE),

-- Tea Drinks
('Earl Grey', 'Classic bergamot-flavored black tea', 'tea', 'Black Tea', 3.25, NULL, 'Medium', 'Regular', 0, TRUE, TRUE, FALSE),
('Matcha Latte', 'Japanese green tea powder with steamed milk', 'tea', 'Green Tea', 4.75, NULL, 'Medium', 'Regular', 140, FALSE, TRUE, FALSE),
('Chamomile', 'Soothing herbal tea', 'tea', 'Herbal', 3.00, NULL, 'None', 'Regular', 0, TRUE, TRUE, FALSE),
('Green Tea', 'Classic green tea', 'tea', 'Green Tea', 2.75, NULL, 'Medium', 'Regular', 0, TRUE, TRUE, FALSE),
('Chai Latte', 'Spiced tea with steamed milk', 'tea', 'Chai', 4.50, NULL, 'Medium', 'Regular', 190, FALSE, TRUE, FALSE),
('Oolong Tea', 'Traditional Chinese tea', 'tea', 'Oolong', 3.50, NULL, 'Medium', 'Regular', 0, TRUE, TRUE, FALSE),
('Peppermint Tea', 'Refreshing herbal tea', 'tea', 'Herbal', 3.00, NULL, 'None', 'Regular', 0, TRUE, TRUE, FALSE),

-- Beer
('Hoppy IPA', 'Bold India Pale Ale with citrus notes', 'beer', 'IPA', 6.50, 6.8, NULL, 'Pint', 180, TRUE, FALSE, FALSE),
('Chocolate Stout', 'Rich stout with chocolate undertones', 'beer', 'Stout', 7.00, 5.2, NULL, 'Pint', 210, TRUE, FALSE, FALSE),
('Wheat Beer', 'Light and refreshing wheat beer', 'beer', 'Wheat', 5.50, 4.5, NULL, 'Pint', 150, TRUE, FALSE, FALSE),
('Seasonal Pumpkin Ale', 'Autumn spiced ale', 'beer', 'Seasonal', 6.75, 5.5, NULL, 'Pint', 165, TRUE, FALSE, TRUE),
('Pilsner', 'Crisp and clean lager', 'beer', 'Lager', 5.25, 4.8, NULL, 'Pint', 140, TRUE, FALSE, FALSE),
('Porter', 'Dark, rich beer with roasted flavors', 'beer', 'Porter', 6.25, 5.8, NULL, 'Pint', 195, TRUE, FALSE, FALSE),
('Pale Ale', 'Hoppy and balanced pale ale', 'beer', 'Pale Ale', 5.75, 5.3, NULL, 'Pint', 165, TRUE, FALSE, FALSE),
('Belgian Wheat', 'Traditional Belgian-style wheat beer', 'beer', 'Wheat', 6.00, 4.9, NULL, 'Pint', 155, TRUE, FALSE, FALSE),
('Saison', 'Farmhouse-style Belgian ale', 'beer', 'Saison', 6.50, 6.2, NULL, 'Pint', 170, TRUE, FALSE, FALSE),
('Amber Ale', 'Malty amber-colored ale', 'beer', 'Amber', 5.50, 5.1, NULL, 'Pint', 160, TRUE, FALSE, FALSE),
('Double IPA', 'Strong hoppy IPA with high alcohol', 'beer', 'IPA', 8.00, 8.5, NULL, 'Pint', 240, TRUE, FALSE, FALSE),

-- Cocktails
('Coffee Martini', 'Espresso-based cocktail', 'cocktail', 'Martini', 12.00, 15.0, 'High', 'Regular', 180, TRUE, TRUE, FALSE),
('Beer Cocktail', 'House beer mixed with seasonal fruit', 'cocktail', 'Beer Cocktail', 8.50, 4.2, NULL, 'Regular', 160, TRUE, FALSE, TRUE),
('Irish Coffee', 'Coffee with Irish whiskey and cream', 'cocktail', 'Coffee Cocktail', 10.50, 8.0, 'High', 'Regular', 220, FALSE, TRUE, FALSE),
('Maple Old Fashioned', 'Canadian twist on classic cocktail', 'cocktail', 'Whiskey', 13.00, 25.0, NULL, 'Regular', 180, TRUE, TRUE, FALSE),

-- Non-Alcoholic
('Sparkling Water', 'Refreshing bubbled water', 'non-alcoholic', 'Water', 2.00, NULL, 'None', 'Regular', 0, TRUE, TRUE, FALSE),
('Fresh Orange Juice', 'Squeezed daily', 'non-alcoholic', 'Juice', 3.50, NULL, 'None', 'Regular', 110, TRUE, TRUE, FALSE),
('Apple Juice', 'Fresh Canadian apple juice', 'non-alcoholic', 'Juice', 3.25, NULL, 'None', 'Regular', 115, TRUE, TRUE, FALSE),
('Hot Chocolate', 'Rich and creamy hot chocolate', 'non-alcoholic', 'Hot Beverage', 4.25, NULL, 'None', 'Regular', 240, FALSE, TRUE, FALSE),
('Iced Tea', 'Refreshing cold tea', 'non-alcoholic', 'Iced Tea', 2.75, NULL, 'Low', 'Regular', 70, TRUE, TRUE, FALSE),

-- Pastries
('Croissant', 'Buttery French pastry', 'pastry', 'Pastry', 3.25, NULL, 'None', 'Regular', 270, FALSE, FALSE, FALSE),
('Blueberry Muffin', 'Fresh baked with local blueberries', 'pastry', 'Muffin', 2.75, NULL, 'None', 'Regular', 320, FALSE, FALSE, FALSE),
('Pain au Chocolat', 'French chocolate pastry', 'pastry', 'Pastry', 3.75, NULL, 'None', 'Regular', 290, FALSE, FALSE, FALSE),
('Bagel with Cream Cheese', 'Fresh bagel with cream cheese', 'pastry', 'Bagel', 4.50, NULL, 'None', 'Regular', 350, FALSE, FALSE, FALSE),
('Maple Cookie', 'Traditional Canadian maple cookie', 'pastry', 'Cookie', 2.25, NULL, 'None', 'Regular', 180, FALSE, FALSE, FALSE),
('Scone', 'Traditional British scone', 'pastry', 'Scone', 3.50, NULL, 'None', 'Regular', 240, FALSE, FALSE, FALSE);

-- Link Cafes to their Drinks
INSERT INTO cafe_drinks (cafe_id, drink_id, is_signature, daily_special_day) VALUES
-- Café des Artisans (cafe_id: 1) - Montreal
(1, 1, TRUE, NULL), (1, 2, TRUE, NULL), (1, 3, FALSE, NULL), (1, 6, FALSE, 'monday'), (1, 10, TRUE, NULL), (1, 11, FALSE, NULL), (1, 12, FALSE, NULL), (1, 14, FALSE, NULL), (1, 34, FALSE, NULL), (1, 35, TRUE, NULL), (1, 36, FALSE, NULL),
-- Le Grind Quotidien (cafe_id: 2) - Montreal
(2, 1, FALSE, NULL), (2, 2, FALSE, NULL), (2, 3, FALSE, NULL), (2, 6, TRUE, NULL), (2, 8, TRUE, NULL), (2, 11, FALSE, NULL), (2, 15, FALSE, 'tuesday'), (2, 22, FALSE, NULL), (2, 34, FALSE, NULL), (2, 35, FALSE, NULL),
-- Torréfacteurs du Plateau (cafe_id: 3) - Montreal
(3, 1, TRUE, NULL), (3, 2, TRUE, NULL), (3, 3, TRUE, NULL), (3, 5, FALSE, NULL), (3, 10, FALSE, NULL), (3, 11, FALSE, NULL), (3, 13, FALSE, NULL), (3, 34, FALSE, NULL), (3, 35, FALSE, NULL), (3, 37, TRUE, NULL),
-- Café du Coin (cafe_id: 4) - Montreal
(4, 1, FALSE, NULL), (4, 2, FALSE, NULL), (4, 4, FALSE, NULL), (4, 11, FALSE, NULL), (4, 13, FALSE, NULL), (4, 22, FALSE, 'friday'), (4, 34, TRUE, NULL), (4, 35, TRUE, NULL), (4, 36, FALSE, NULL), (4, 38, TRUE, NULL),
-- Café Vitesse (cafe_id: 5) - Laval
(5, 1, TRUE, NULL), (5, 2, FALSE, NULL), (5, 4, FALSE, NULL), (5, 6, FALSE, NULL), (5, 8, TRUE, NULL), (5, 10, FALSE, NULL), (5, 34, FALSE, NULL), (5, 35, FALSE, NULL), (5, 36, FALSE, NULL),
-- Café des Îles (cafe_id: 6) - Laval
(6, 1, FALSE, NULL), (6, 3, FALSE, NULL), (6, 5, FALSE, NULL), (6, 11, FALSE, NULL), (6, 12, FALSE, NULL), (6, 13, TRUE, 'wednesday'), (6, 22, FALSE, NULL), (6, 34, FALSE, NULL), (6, 35, FALSE, NULL),
-- Café du Château (cafe_id: 7) - Quebec City
(7, 1, FALSE, NULL), (7, 2, TRUE, NULL), (7, 10, TRUE, NULL), (7, 11, FALSE, NULL), (7, 12, FALSE, NULL), (7, 14, FALSE, NULL), (7, 34, FALSE, NULL), (7, 35, FALSE, NULL), (7, 36, TRUE, NULL), (7, 37, FALSE, NULL),
-- Le Petit Torréfacteur (cafe_id: 8) - Quebec City
(8, 1, TRUE, NULL), (8, 2, TRUE, NULL), (8, 3, TRUE, NULL), (8, 5, FALSE, NULL), (8, 10, TRUE, NULL), (8, 11, FALSE, NULL), (8, 34, FALSE, NULL), (8, 35, FALSE, NULL), (8, 37, TRUE, NULL),
-- Café des Plaines (cafe_id: 9) - Quebec City
(9, 1, FALSE, NULL), (9, 3, FALSE, NULL), (9, 4, FALSE, NULL), (9, 12, FALSE, NULL), (9, 14, TRUE, NULL), (9, 15, FALSE, 'monday'), (9, 22, FALSE, NULL), (9, 34, FALSE, NULL), (9, 35, FALSE, NULL),
-- Café Universitaire (cafe_id: 10) - Sherbrooke
(10, 1, FALSE, NULL), (10, 2, FALSE, NULL), (10, 4, FALSE, NULL), (10, 6, TRUE, NULL), (10, 8, FALSE, NULL), (10, 23, FALSE, NULL), (10, 34, FALSE, NULL), (10, 35, FALSE, NULL), (10, 38, FALSE, NULL),
-- Torréfaction Estrie (cafe_id: 11) - Sherbrooke
(11, 1, TRUE, NULL), (11, 2, FALSE, NULL), (11, 10, TRUE, NULL), (11, 11, FALSE, NULL), (11, 12, FALSE, NULL), (11, 13, FALSE, NULL), (11, 34, FALSE, NULL), (11, 35, FALSE, NULL), (11, 37, FALSE, NULL),
-- Café Mauricie (cafe_id: 12) - Trois-Rivières
(12, 1, FALSE, NULL), (12, 2, FALSE, NULL), (12, 3, FALSE, NULL), (12, 11, FALSE, NULL), (12, 13, TRUE, NULL), (12, 22, FALSE, 'thursday'), (12, 34, FALSE, NULL), (12, 35, FALSE, NULL), (12, 36, FALSE, NULL),
-- Café Outaouais (cafe_id: 13) - Gatineau
(13, 1, FALSE, NULL), (13, 2, FALSE, NULL), (13, 4, FALSE, NULL), (13, 11, FALSE, NULL), (13, 12, FALSE, NULL), (13, 14, FALSE, NULL), (13, 34, FALSE, NULL), (13, 35, FALSE, NULL), (13, 22, FALSE, NULL),
-- Café du Fjord (cafe_id: 14) - Chicoutimi
(14, 1, FALSE, NULL), (14, 2, FALSE, NULL), (14, 9, TRUE, NULL), (14, 10, TRUE, NULL), (14, 11, FALSE, NULL), (14, 13, FALSE, NULL), (14, 34, FALSE, NULL), (14, 35, FALSE, NULL), (14, 37, FALSE, NULL);

-- Link Breweries to their Drinks
INSERT INTO brewery_drinks (brewery_id, drink_id, is_flagship, seasonal_availability, abv, ibu) VALUES
-- Brasserie du Houblon (brewery_id: 1) - Montreal
(1, 18, TRUE, 'Year-round', 6.8, 65), (1, 19, FALSE, 'Year-round', 5.2, 35), (1, 20, FALSE, 'Summer', 4.5, 20), (1, 24, FALSE, 'Year-round', 5.8, 45), (1, 25, FALSE, 'Year-round', 5.3, 40), (1, 28, FALSE, 'Fall', 5.5, 30), (1, 33, FALSE, NULL, NULL, NULL),
-- Taverne Industrielle (brewery_id: 2) - Montreal
(2, 22, TRUE, 'Year-round', 4.8, 25), (2, 20, FALSE, 'Summer', 4.5, 20), (2, 26, FALSE, 'Year-round', 4.9, 18), (2, 27, FALSE, 'Year-round', 6.2, 25), (2, 33, FALSE, NULL, NULL, NULL), (2, 31, FALSE, NULL, NULL, NULL),
-- Brasseurs du Plateau (brewery_id: 3) - Montreal
(3, 18, TRUE, 'Year-round', 6.8, 65), (3, 22, FALSE, 'Year-round', 4.8, 25), (3, 27, TRUE, 'Year-round', 6.2, 25), (3, 25, FALSE, 'Year-round', 5.3, 40), (3, 31, FALSE, NULL, NULL, NULL), (3, 33, FALSE, NULL, NULL, NULL),
-- Microbrasserie des Îles (brewery_id: 4) - Laval
(4, 18, TRUE, 'Year-round', 6.8, 65), (4, 24, FALSE, 'Winter', 5.8, 45), (4, 20, FALSE, 'Year-round', 4.5, 20), (4, 21, TRUE, 'Fall', 5.5, 30), (4, 28, FALSE, 'Year-round', 5.1, 35), (4, 33, FALSE, NULL, NULL, NULL),
-- Brasserie Laurentienne (brewery_id: 5) - Laval
(5, 18, FALSE, 'Year-round', 6.8, 65), (5, 19, TRUE, 'Year-round', 5.2, 35), (5, 28, TRUE, 'Year-round', 5.1, 35), (5, 24, FALSE, 'Year-round', 5.8, 45), (5, 33, FALSE, NULL, NULL, NULL),
-- Brasserie de la Capitale (brewery_id: 6) - Quebec City
(6, 28, TRUE, 'Year-round', 5.1, 35), (6, 20, FALSE, 'Summer', 4.5, 20), (6, 26, TRUE, 'Year-round', 4.9, 18), (6, 25, FALSE, 'Year-round', 5.3, 40), (6, 31, FALSE, NULL, NULL, NULL), (6, 32, FALSE, NULL, NULL, NULL),
-- Microbrasserie des Remparts (brewery_id: 7) - Quebec City
(7, 28, TRUE, 'Year-round', 5.1, 35), (7, 18, FALSE, 'Year-round', 6.8, 65), (7, 24, FALSE, 'Year-round', 5.8, 45), (7, 19, FALSE, 'Winter', 5.2, 35), (7, 33, FALSE, NULL, NULL, NULL),
-- Brasserie des Cantons (brewery_id: 8) - Sherbrooke
(8, 18, TRUE, 'Year-round', 6.8, 65), (8, 22, FALSE, 'Year-round', 4.8, 25), (8, 21, FALSE, 'Fall', 5.5, 30), (8, 25, FALSE, 'Year-round', 5.3, 40), (8, 33, FALSE, NULL, NULL, NULL),
-- Microbrasserie Mauricie (brewery_id: 9) - Trois-Rivières
(9, 22, TRUE, 'Year-round', 4.8, 25), (9, 19, FALSE, 'Year-round', 5.2, 35), (9, 27, FALSE, 'Year-round', 6.2, 25), (9, 24, FALSE, 'Winter', 5.8, 45), (9, 33, FALSE, NULL, NULL, NULL),
-- Brasserie de la Capitale-Nationale (brewery_id: 10) - Gatineau
(10, 28, TRUE, 'Year-round', 5.1, 35), (10, 20, FALSE, 'Summer', 4.5, 20), (10, 18, FALSE, 'Year-round', 6.8, 65), (10, 22, FALSE, 'Year-round', 4.8, 25), (10, 33, FALSE, NULL, NULL, NULL),
-- Brasserie du Fjord (brewery_id: 11) - Chicoutimi
(11, 24, TRUE, 'Year-round', 5.8, 45), (11, 18, FALSE, 'Year-round', 6.8, 65), (11, 20, FALSE, 'Summer', 4.5, 20), (11, 19, FALSE, 'Winter', 5.2, 35), (11, 33, FALSE, NULL, NULL, NULL);

-- Insert Reviews
INSERT INTO reviews (customer_id, location_type, location_id, rating, title, comment, visited_date, drink_ordered, service_rating, atmosphere_rating, value_rating, would_recommend) VALUES
-- Cafe Reviews - Montreal
(1, 'cafe', 1, 5, 'Perfect Morning Spot', 'Love their single origin coffee! The baristas really know their craft.', '2024-01-15', 'Cappuccino', 5, 5, 4, TRUE),
(2, 'cafe', 1, 4, 'Great Coffee, Crowded', 'Excellent coffee but gets very busy in the morning.', '2024-01-20', 'Cold Brew', 4, 3, 4, TRUE),
(9, 'cafe', 1, 5, 'House Roasted Excellence', 'Their house-roasted beans make all the difference!', '2024-02-28', 'French Press', 5, 4, 5, TRUE),
(3, 'cafe', 2, 4, 'Good for Work', 'Reliable wifi and good coffee. Perfect for remote work.', '2024-02-01', 'Nitro Cold Brew', 4, 4, 4, TRUE),
(11, 'cafe', 2, 3, 'Expensive but Good', 'Quality coffee but pricey for what you get.', '2024-03-10', 'Latte', 4, 4, 2, TRUE),
(4, 'cafe', 3, 5, 'Amazing Latte Art', 'The barista made incredible latte art. Coffee was exceptional too!', '2024-02-10', 'Cappuccino', 5, 5, 5, TRUE),
(12, 'cafe', 3, 5, 'Artsy Vibe Perfect', 'Love the creative atmosphere and exceptional espresso.', '2024-03-15', 'Espresso', 5, 5, 4, TRUE),
(5, 'cafe', 4, 4, 'Homey Atmosphere', 'Love the cozy vibe and their pastries are homemade.', '2024-02-15', 'Earl Grey', 4, 5, 5, TRUE),
(13, 'cafe', 4, 4, 'Great Pastries', 'Coffee is good but the pastries are the real star!', '2024-03-12', 'Americano', 3, 5, 4, TRUE),

-- Cafe Reviews - Laval
(1, 'cafe', 5, 4, 'Strong Coffee', 'Perfect for early morning energy boost. Very strong espresso.', '2024-02-20', 'Espresso', 4, 4, 4, TRUE),
(14, 'cafe', 5, 5, 'High Energy Place', 'Great for getting work done with excellent coffee.', '2024-03-18', 'Nitro Cold Brew', 5, 4, 4, TRUE),
(6, 'cafe', 6, 4, 'Island Vibes', 'Relaxing atmosphere with tropical theme. Good coffee.', '2024-03-05', 'Latte', 4, 5, 4, TRUE),
(15, 'cafe', 6, 3, 'Decent Spot', 'Nice place to hang out but coffee could be stronger.', '2024-03-20', 'Chai Latte', 3, 4, 4, TRUE),

-- Cafe Reviews - Quebec City
(9, 'cafe', 7, 5, 'Historic Charm', 'Beautiful historic setting with excellent French roast coffee.', '2024-02-25', 'French Press', 5, 5, 4, TRUE),
(16, 'cafe', 7, 4, 'Tourist Friendly', 'Great spot near Old Quebec, good for visitors.', '2024-03-08', 'Cappuccino', 4, 5, 3, TRUE),
(10, 'cafe', 8, 5, 'Artisanal Excellence', 'Best coffee roastery in Quebec City! Amazing quality.', '2024-03-02', 'Espresso', 5, 4, 4, TRUE),
(17, 'cafe', 8, 5, 'Coffee Perfection', 'Every cup is perfectly crafted. True artisans at work.', '2024-03-14', 'Cold Brew', 5, 4, 5, TRUE),
(18, 'cafe', 9, 4, 'Modern with a View', 'Great view of Plains of Abraham, good organic coffee.', '2024-03-22', 'Mocha', 4, 5, 4, TRUE),

-- Cafe Reviews - Other Cities
(10, 'cafe', 10, 3, 'Student Budget Friendly', 'Cheap coffee for students but quality is just okay.', '2024-02-18', 'Americano', 3, 3, 5, TRUE),
(19, 'cafe', 11, 4, 'Local Bean Excellence', 'Love supporting local. Their Eastern Townships beans are great!', '2024-03-16', 'French Press', 4, 4, 4, TRUE),
(20, 'cafe', 12, 4, 'Regional Pride', 'Great representation of Mauricie region in their coffee.', '2024-03-25', 'Latte', 4, 4, 4, TRUE),
(11, 'cafe', 13, 3, 'Bilingual Service', 'Good bilingual service but coffee is average.', '2024-03-11', 'Cappuccino', 4, 3, 3, TRUE),
(16, 'cafe', 14, 5, 'Fjord Views Amazing', 'Incredible scenery with mountain coffee that matches the view!', '2024-03-28', 'Maple Latte', 5, 5, 4, TRUE),

-- Brewery Reviews - Montreal
(2, 'brewery', 1, 5, 'Best IPA in Town', 'Their IPA Québécoise is absolutely perfect. Great hop balance.', '2024-01-25', 'Hoppy IPA', 5, 4, 4, TRUE),
(6, 'brewery', 1, 4, 'Good Selection', 'Nice variety of beers. The stout was rich and creamy.', '2024-02-05', 'Chocolate Stout', 4, 4, 4, TRUE),
(14, 'brewery', 1, 5, 'Craft Beer Heaven', 'Everything they make is exceptional. True craft brewing.', '2024-03-12', 'Porter', 5, 4, 4, TRUE),
(8, 'brewery', 2, 4, 'Industrial Vibe', 'Cool atmosphere, decent beer selection.', '2024-02-12', 'Pilsner', 4, 5, 3, TRUE),
(15, 'brewery', 2, 3, 'Hit or Miss', 'Some beers are great, others not so much.', '2024-03-19', 'Belgian Wheat', 3, 4, 3, TRUE),
(2, 'brewery', 3, 5, 'Innovative Flavors', 'Love trying their seasonal experiments. Always something new!', '2024-02-18', 'Hoppy IPA', 5, 5, 4, TRUE),
(12, 'brewery', 3, 4, 'Trendy Spot', 'Great atmosphere for young crowd. Good beer variety.', '2024-03-21', 'Saison', 4, 5, 4, TRUE),

-- Brewery Reviews - Laval
(6, 'brewery', 4, 4, 'Family Friendly', 'Great place to bring kids. Good beer and food too.', '2024-02-22', 'Wheat Beer', 4, 5, 4, TRUE),
(18, 'brewery', 4, 5, 'Regional Pride', 'Love their Tonnerre des Îles IPA. Best in Laval!', '2024-03-17', 'Hoppy IPA', 5, 4, 4, TRUE),
(8, 'brewery', 5, 5, 'Mountain Water Magic', 'You can taste the natural mountain water in every beer!', '2024-02-25', 'Chocolate Stout', 5, 5, 4, TRUE),
(19, 'brewery', 5, 4, 'Consistently Good', 'Never had a bad beer here. Reliable quality.', '2024-03-23', 'Amber Ale', 4, 4, 4, TRUE),

-- Brewery Reviews - Quebec City
(9, 'brewery', 6, 5, 'Historic Brewing', 'Château Ale in historic Quebec City is perfect combination!', '2024-03-01', 'Amber Ale', 5, 5, 4, TRUE),
(16, 'brewery', 6, 4, 'Upscale Experience', 'More expensive but quality matches the price.', '2024-03-13', 'Belgian Wheat', 4, 5, 3, TRUE),
(17, 'brewery', 7, 4, 'Heritage Brewing', 'Love their connection to Quebec City heritage.', '2024-03-09', 'Porter', 4, 4, 4, TRUE),
(20, 'brewery', 7, 5, 'Rempart Rouge Amazing', 'Their signature red ale is absolutely perfect!', '2024-03-24', 'Amber Ale', 5, 4, 5, TRUE),

-- Brewery Reviews - Other Cities
(10, 'brewery', 8, 4, 'Eastern Townships Pride', 'Great use of local ingredients from the region.', '2024-03-07', 'Hoppy IPA', 4, 4, 4, TRUE),
(18, 'brewery', 9, 4, 'Mauricie Heritage', 'Trifluvienne Blonde represents the region well.', '2024-03-15', 'Pilsner', 4, 4, 4, TRUE),
(11, 'brewery', 10, 3, 'Bilingual Brewing', 'Good concept but beer quality is inconsistent.', '2024-03-26', 'Amber Ale', 3, 4, 3, TRUE),
(19, 'brewery', 11, 5, 'Fjord Noir Perfection', 'Their porter with Saguenay inspiration is incredible!', '2024-03-29', 'Porter', 5, 4, 4, TRUE),

-- Additional reviews for better data distribution
(1, 'cafe', 2, 3, 'Not My Favorite', 'Coffee was okay but not exceptional for the price.', '2024-03-01', 'Cold Brew', 3, 3, 2, FALSE),
(2, 'cafe', 3, 5, 'Consistently Great', 'Always excellent service and coffee quality.', '2024-03-05', 'Espresso', 5, 4, 4, TRUE),
(6, 'brewery', 2, 3, 'Average Experience', 'Beer was fine but nothing special stood out.', '2024-03-08', 'Wheat Beer', 3, 4, 3, TRUE),
(13, 'cafe', 8, 4, 'Worth the Trip', 'Traveled from Montreal just for their coffee. Worth it!', '2024-03-30', 'Cappuccino', 4, 4, 3, TRUE),
(14, 'brewery', 6, 5, 'Best in Quebec', 'This might be the best brewery in all of Quebec!', '2024-03-31', 'Saison', 5, 5, 4, TRUE);

-- Insert Events
INSERT INTO events (location_type, location_id, name, description, event_type, event_date, start_time, end_time, price, max_attendees, requires_reservation) VALUES
-- Montreal Events
('cafe', 1, 'Latte Art Workshop', 'Learn to create beautiful latte art with our expert baristas', 'workshop', '2024-04-15', '14:00:00', '16:00:00', 25.00, 12, TRUE),
('cafe', 1, 'Single Origin Tasting', 'Explore coffee origins from around the world', 'tasting', '2024-05-10', '19:00:00', '21:00:00', 18.00, 15, TRUE),
('cafe', 2, 'Coffee Cupping', 'Professional coffee tasting and education', 'tasting', '2024-04-22', '10:00:00', '12:00:00', 20.00, 15, TRUE),
('cafe', 2, 'Remote Work Social', 'Networking event for remote workers', 'other', '2024-05-08', '18:00:00', '20:00:00', 5.00, 25, FALSE),
('cafe', 3, 'Open Mic Night', 'Showcase your talent at our monthly open mic', 'open_mic', '2024-04-20', '19:00:00', '22:00:00', 0.00, NULL, FALSE),
('cafe', 3, 'Latte Art Competition', 'Compete for the best latte art in Montreal', 'other', '2024-05-18', '15:00:00', '18:00:00', 10.00, 20, TRUE),
('cafe', 4, 'French Pastry Workshop', 'Learn to make traditional French pastries', 'workshop', '2024-04-25', '16:00:00', '19:00:00', 35.00, 8, TRUE),
('brewery', 1, 'IPA Tasting Flight', 'Taste 5 different IPAs with our brewmaster', 'tasting', '2024-04-18', '18:00:00', '20:00:00', 15.00, 20, TRUE),
('brewery', 1, 'Brewery Tour & Tasting', 'Behind-the-scenes brewery tour with tastings', 'tasting', '2024-05-12', '14:00:00', '16:00:00', 12.00, 25, TRUE),
('brewery', 2, 'Industrial Music Night', 'Live industrial music in our taproom', 'live_music', '2024-04-27', '20:00:00', '23:00:00', 8.00, 40, FALSE),
('brewery', 3, 'Trivia Tuesday', 'Weekly trivia night with beer prizes', 'trivia', '2024-04-16', '20:00:00', '22:00:00', 0.00, NULL, FALSE),
('brewery', 3, 'Seasonal Beer Launch', 'Launch party for our new seasonal brew', 'other', '2024-05-15', '17:00:00', '21:00:00', 5.00, 50, FALSE),

-- Laval Events
('cafe', 5, 'Early Bird Coffee Club', 'Special discounts for early morning coffee lovers', 'other', '2024-04-12', '05:30:00', '07:00:00', 0.00, NULL, FALSE),
('cafe', 6, 'Tropical Coffee Tasting', 'Taste coffee blends inspired by tropical islands', 'tasting', '2024-04-28', '13:00:00', '15:00:00', 22.00, 12, TRUE),
('brewery', 4, 'Family Beer Garden Day', 'Family-friendly event with games and food', 'other', '2024-05-05', '12:00:00', '18:00:00', 0.00, NULL, FALSE),
('brewery', 5, 'Mountain Water Beer Education', 'Learn about our natural mountain water brewing process', 'workshop', '2024-04-30', '19:00:00', '21:00:00', 15.00, 15, TRUE),

-- Quebec City Events
('cafe', 7, 'Historic Quebec Coffee Walk', 'Guided coffee tour through Old Quebec', 'other', '2024-04-14', '10:00:00', '12:00:00', 30.00, 10, TRUE),
('cafe', 8, 'Artisanal Roasting Workshop', 'Learn the art of coffee roasting from masters', 'workshop', '2024-05-02', '14:00:00', '17:00:00', 45.00, 6, TRUE),
('cafe', 9, 'Plains of Abraham Coffee Appreciation', 'Coffee tasting with view of historic plains', 'tasting', '2024-04-21', '16:00:00', '18:00:00', 25.00, 20, TRUE),
('brewery', 6, 'Château Beer Pairing Dinner', 'Multi-course dinner with beer pairings', 'other', '2024-05-20', '18:00:00', '22:00:00', 75.00, 30, TRUE),
('brewery', 7, 'Quebec Heritage Brewing Workshop', 'Learn traditional Quebec brewing methods', 'workshop', '2024-04-26', '15:00:00', '18:00:00', 40.00, 12, TRUE),

-- Sherbrooke Events
('cafe', 10, 'Student Study Night', 'Extended hours with study-friendly atmosphere', 'other', '2024-04-17', '20:00:00', '02:00:00', 0.00, NULL, FALSE),
('cafe', 11, 'Eastern Townships Coffee Festival', 'Celebration of local coffee and culture', 'other', '2024-05-25', '10:00:00', '16:00:00', 15.00, NULL, FALSE),
('brewery', 8, 'Local Ingredients Showcase', 'Taste beers made with Eastern Townships ingredients', 'tasting', '2024-05-11', '17:00:00', '19:00:00', 20.00, 25, TRUE),

-- Trois-Rivières Events
('cafe', 12, 'Mauricie Coffee Heritage', 'Learn about coffee culture in the Mauricie region', 'workshop', '2024-04-24', '14:00:00', '16:00:00', 18.00, 15, TRUE),
('brewery', 9, 'Trifluvienne Blonde Launch Party', 'Celebrate our signature blonde beer', 'other', '2024-05-07', '19:00:00', '22:00:00', 8.00, 40, FALSE),

-- Gatineau Events
('cafe', 13, 'Bilingual Coffee Conversation', 'Practice French/English over coffee', 'other', '2024-04-19', '18:00:00', '20:00:00', 5.00, 20, FALSE),
('brewery', 10, 'Capital Region Beer Summit', 'Beer tasting representing Ottawa-Gatineau region', 'tasting', '2024-05-16', '16:00:00', '19:00:00', 25.00, 30, TRUE),

-- Chicoutimi Events
('cafe', 14, 'Saguenay Fjord Coffee Experience', 'Coffee tasting with scenic fjord views', 'tasting', '2024-05-22', '09:00:00', '11:00:00', 35.00, 12, TRUE),
('brewery', 11, 'Fjord Noir Porter Festival', 'Celebration of our signature porter with food trucks', 'other', '2024-05-30', '15:00:00', '21:00:00', 10.00, NULL, FALSE);

-- =============================================
-- CREATE VIEWS FOR COMMON QUERIES
-- =============================================

-- View for all drinks offered at each location
CREATE VIEW location_drinks AS
SELECT
    'cafe' as location_type,
    c.id as location_id,
    c.name as location_name,
    c.city,
    d.name as drink_name,
    d.category,
    d.price,
    cd.is_signature,
    cd.daily_special_day
FROM cafes c
JOIN cafe_drinks cd ON c.id = cd.cafe_id
JOIN drinks d ON cd.drink_id = d.id
UNION ALL
SELECT
    'brewery' as location_type,
    b.id as location_id,
    b.name as location_name,
    b.city,
    d.name as drink_name,
    d.category,
    d.price,
    bd.is_flagship as is_signature,
    NULL as daily_special_day
FROM breweries b
JOIN brewery_drinks bd ON b.id = bd.brewery_id
JOIN drinks d ON bd.drink_id = d.id;

-- View for average ratings per location
CREATE VIEW location_ratings AS
SELECT
    'cafe' as location_type,
    c.id as location_id,
    c.name as location_name,
    c.city,
    c.state,
    COALESCE(AVG(r.rating), 0) as average_rating,
    COUNT(r.id) as total_reviews
FROM cafes c
LEFT JOIN reviews r ON r.location_type = 'cafe' AND r.location_id = c.id
GROUP BY c.id
UNION ALL
SELECT
    'brewery' as location_type,
    b.id as location_id,
    b.name as location_name,
    b.city,
    b.state,
    COALESCE(AVG(r.rating), 0) as average_rating,
    COUNT(r.id) as total_reviews
FROM breweries b
LEFT JOIN reviews r ON r.location_type = 'brewery' AND r.location_id = b.id
GROUP BY b.id;

-- View for customers who reviewed multiple locations
CREATE VIEW active_reviewers AS
SELECT
    c.id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.id) as total_reviews,
    COUNT(DISTINCT CONCAT(r.location_type, '-', r.location_id)) as locations_reviewed,
    AVG(r.rating) as average_rating_given
FROM customers c
JOIN reviews r ON c.id = r.customer_id
GROUP BY c.id
HAVING total_reviews > 1;

-- =============================================
-- SAMPLE QUERIES FOR PRACTICE
-- =============================================

/*
-- 1. All drinks offered at a specific location
SELECT d.name, d.category, d.price, cd.is_signature
FROM cafe_drinks cd
JOIN drinks d ON cd.drink_id = d.id
WHERE cd.cafe_id = :cafe_id;

-- 2. Average review per café
SELECT c.name, AVG(r.rating) as average_rating, COUNT(r.id) as review_count
FROM cafes c
LEFT JOIN reviews r ON r.location_type = 'cafe' AND r.location_id = c.id
GROUP BY c.id, c.name;

-- 3. Customers who reviewed multiple shops
SELECT c.first_name, c.last_name, COUNT(DISTINCT CONCAT(r.location_type, '-', r.location_id)) as shops_reviewed
FROM customers c
JOIN reviews r ON c.id = r.customer_id
GROUP BY c.id
HAVING shops_reviewed > 1;

-- 4. Find all coffee shops with outdoor seating in Montreal
SELECT name, address, specialty, average_rating
FROM cafes
WHERE city = 'Montreal' AND outdoor_seating = TRUE;

-- 5. Best rated breweries that serve IPAs
SELECT b.name, b.city, AVG(r.rating) as avg_rating
FROM breweries b
JOIN brewery_drinks bd ON b.id = bd.brewery_id
JOIN drinks d ON bd.drink_id = d.id
LEFT JOIN reviews r ON r.location_type = 'brewery' AND r.location_id = b.id
WHERE d.subcategory = 'IPA'
GROUP BY b.id
ORDER BY avg_rating DESC;

-- 6. Coffee shops with WiFi perfect for remote work
SELECT name, city, wifi_available, atmosphere, price_range, average_rating
FROM cafes
WHERE wifi_available = TRUE AND atmosphere IN ('modern', 'cozy')
ORDER BY average_rating DESC;

-- 7. Seasonal drinks currently available
SELECT d.name, d.category, d.price, d.description
FROM drinks d
WHERE d.seasonal = TRUE AND d.available = TRUE;

-- 8. Most active reviewers
SELECT c.first_name, c.last_name, COUNT(r.id) as review_count, AVG(r.rating) as avg_rating_given
FROM customers c
JOIN reviews r ON c.id = r.customer_id
GROUP BY c.id
ORDER BY review_count DESC
LIMIT 5;
*/

-- =============================================
-- END OF DATABASE SETUP
-- =============================================

-- Display success message
SELECT 'Brewery & Coffee Shop Finder database created successfully! Featuring Montreal and Laval locations. Perfect for PDO practice with interesting queries.' AS message;
