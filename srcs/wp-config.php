<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'ldideric' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wachtwoord' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'd,|SeH<FG(:@kjz@)-?^bnEex]A_Br?<@}b5&sJc8zLzgEuUNy4DSp!FB[E+%>| ');
define('SECURE_AUTH_KEY',  'Un?{1Vg?})IOuQ)qQ Jf{hyHyro+VWp5rSw6l`?sC=B}3AZ%N]M;4WGSi 2/jM|g');
define('LOGGED_IN_KEY',    'g<FrHAwcXRV=QdEemy,C`poMDX~`zFL9`-?yU<k6XpU5OQz>i>-~USl Ib<m!K9f');
define('NONCE_KEY',        'x&8%C4[nr_gk!x&|7yG)(3fj@|rfFMS`Aa_%#+LT0N+UWl)*eN|$O48~#U`PZ;=D');
define('AUTH_SALT',        'FoJQ|aDcyeyO:L Y)vXKlH|Wptc1}?*s(4jim|{8[c,b<e<6X*vz|P+SEmB2J@Iz');
define('SECURE_AUTH_SALT', '<QuJ#izm]_X~f81m.3hR9@UL}E/?$L[h,IYyQ7Q) e~.Bf/!O]@`sem@MjvuCKs9');
define('LOGGED_IN_SALT',   '5vb1z/QQC)IDiRr)~3tQ`f)K7@.V:zq-{Uu6rA{G9wZ8?4sR.`=~-U[7nqYc>.-W');
define('NONCE_SALT',       'K#J[`]ZnR>C *Wq93Y$@M~~6Mh5acgG-x S|:^m,dPkmw$`$+<i-M`=]q$@k-r#/');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
