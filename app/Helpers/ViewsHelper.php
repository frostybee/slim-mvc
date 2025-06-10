<?php

namespace App\Helpers;

class ViewsHelper
{


    /**
     * Load the common header for the page.
     *
     * @param string $page_title The title of the page.
     * @return void
     */
    public static function loadHeader(string $page_title): void
    {
        $page_title = $page_title ?? 'Default Title';
        require_once APP_VIEWS_PATH . '/common/header.php';
    }

    /**
     * Load the common JavaScript scripts for the page.
     *
     * @return void
     */
    public static function loadJsScripts(): void
    {
        require_once APP_VIEWS_PATH . '/common/js-scripts.php';
    }

    /**
     * Load the common footer for the page.
     *
     * @return void
     */
    public static function loadFooter(): void
    {
        require_once APP_VIEWS_PATH . '/common/footer.php';
    }

    /**
     * A helper method to render a <select> element with options.
     *
     * @param array $items The items to render the <select> options for.
     * @param string $previous_select The previous <select> value.
     * @param string $value_key The key of the value to render in the <option> element.
     * @param string $option_key The key of the option to render in the <option> element.
     * @return string The rendered <select> element with options.
     */
    public static function renderSelectOptions(array $items, string $previous_select, string $value_key, string $option_key): string
    {
        $options = '';
        $options .= '<option value="" selected>-- Select --</option>';

        $selected = '';
        foreach ($items as $key => $item) {
            $selected = (isset($previous_select) && $previous_select == $item[$value_key]) ? 'selected' : '';
            $options .= '<option value="' . $item[$value_key] . '" ' . $selected . '>' . $item[$option_key] . '</option>';
        }

        return $options;
    }
}
