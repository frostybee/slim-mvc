<?php

declare(strict_types=1);

/**
 * This file contains various helper functions that can be used throughout the
 * application. These functions are not part of any class and can be called
 * directly.
 */


/**
 * dd: dump and die.
 *
 * Outputs the content of the supplied variable and terminates the execution
 * of the application.
 *
 * @param  mixed $data The variable whose content needs to be dumped.
 * @return void
 */
function dd($data)
{
    echo '<pre>';
    var_dump($data);
    echo '</pre>';
    die();
}

/**
 * Removes the trailing seconds from the supplied date.
 *
 * @param  mixed $date The date in string representation to be formatted.
 * @return string The formatted date without seconds.
 */
function date_remove_secs(string $date): string
{
    return date('Y-m-d H:i', strtotime($date));
}
