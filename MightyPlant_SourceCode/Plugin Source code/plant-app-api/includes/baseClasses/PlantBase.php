<?php

/**
 * @package  PlantAppPlugin
 */

namespace Includes\baseClasses;

class PlantBase {

	public $plugin_path;

	public $nameSpace;

	public $plugin_url;

	public $plugin;

	public $dbConfig;

	private $pluginPrefix;

	public $plugin_version;


	public function __construct() {

		$this->plugin_path = plugin_dir_path( dirname( __FILE__, 2 ) );
		$this->plugin_url  = plugin_dir_url( dirname( __FILE__, 2 ) );

		$this->nameSpace    = PLANTAPP_API_NAMESPACE;
		$this->pluginPrefix = PLANTAPP_API_PREFIX;

		$this->plugin_version = PLANTAPP_API_VERSION;

		$this->plugin = plugin_basename( dirname( __FILE__, 3 ) ) . '/plant-app-api.php';

		$this->dbConfig = [
			'user' => DB_USER,
			'pass' => DB_PASSWORD,
			'db'   => DB_NAME,
			'host' => DB_HOST
		];

	}

	public function get_namespace() {
		return $this->nameSpace;
	}

	protected function getPluginPrefix() {
		return $this->pluginPrefix;
	}

}
