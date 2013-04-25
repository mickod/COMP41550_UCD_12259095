<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Mesh_display_server_model
 *
 * This Model is a simple proof of concept server model for Mesh Display Server.
 * Note lines like: '$this->client_text = $_POST['client_text'];' are not secure but is ok for a test system
 *
*/

class Mesh_display_server_model extends CI_Model {
	
	var $event_id   = '';
    var $client_id = '';
    var $client_text    = '';

    function __construct()
    {
        parent::__construct();
    }

    function create_event($newEvent)
    {
		//This method adds a new event to the database
		$this->load->database();
        $this->event_id = $newEvent;
        $this->client_id = 'CONTROLLER';
        $this->client_text = '';

        $this->db->insert('events', $this);
    }

    function delete_event($delete_event_id)
    {
		//This method deletes all entries for a given event from the database
		$this->load->database();
		$this->event_id = $delete_event_id;
		$this->db->delete('events', array('event_id' => $this->event_id));

    }

    function update_client_text($theClientsEvent, $clientToUpdate, $clientTextToUpdate)
    {
		//This method updates the text for a given client
		$this->load->database();
		$this->event_id = $theClientsEvent; 
        $this->client_text = $clientTextToUpdate;
		$this->client_id = $clientToUpdate;

        $this->db->update('events', $this, array('client_id' => $this->client_id));
    }

    function add_client_to_event($eventToAddClientTo, $clientToAdd)
    {
		//This method adds a new clint to an event in the database
		//Note at this time no checking is done to make sure the event exists
		//The text is set to blank initially
		$this->load->database();
        $this->event_id = $eventToAddClientTo; 
        $this->client_id = $clientToAdd;
        $this->client_text = '';

        $this->db->insert('events', $this);
    }

    function delete_client_from_event($clientToDelete)
    {
		//This method removes a client from an event in the database
		$this->load->database();
		$this->client_id = $clientToDelete;
		$this->db->delete('events', array('client_id' => $this->client_id)); 
    }

	function get_clients_for_event($eventToGetClientsFrom) {
		
		//This method returns all clients for an event
		$this->load->database();
		$this->event_id = $eventToGetClientsFrom; 
		$query = $this->db->get_where('events', array('event_id' => $this->event_id));
		return $query->result_array();
	}
	
	function get_text_for_client($clientToGetTextFor) {
		
		//This method returns the text for a given client
		$this->load->database();
		$this->client_id = $clientToGetTextFor; 
		$query = $this->db->get_where('events', array('client_id' => $this->client_id));
		//There shoudl only ever be one entry per client and this should be checked but 
		//it is simply returned here in this proof of concept
		return $query->row();
	}
}