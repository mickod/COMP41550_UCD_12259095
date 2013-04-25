<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Example
 *
 * Mesh_display_server_controller
 *
 * This controller is a simple proof of concept server controller for Mesh Display Server.
 * Note lines like: '$this->client_text = $_POST['client_text'];' are not secure but is ok for a test system
 * It is built on the example codeigniter rest server created by Phil Sturgeon (hence the name example which has not been changed yet)
 *
*/


// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH.'/libraries/REST_Controller.php';

class Example extends REST_Controller
{

	//-------- MeshDisplayController requests -----------//

    function event_post() {

		//This method add an event to the system
	
	    if(!$this->input->post('event_id'))
        {
        	$this->response(array('error' => 'event_id missing in event post request'), 400);
        }

		//Load the model and ask it to create the event
		$this->load->model('Mesh_display_server_model');
		$this->Mesh_display_server_model->create_event($this->input->post('event_id'));
        
		//Need to add error checeks here - ok for proof of concept
        $this->response("Created event", 200); // 200 being the HTTP response code
    }

    function event_delete() {
    
		//This method removes and event from the system

	    if(!$this->delete('event_id'))
        {
        	$this->response(array('error' => 'event_id missing in event delete request'), 400);
        }
	
		//Load the model and ask it to delete the event
		$this->load->model('Mesh_display_server_model');
		$this->Mesh_display_server_model->delete_event($this->delete('event_id'));
        
		//Need to add error checeks here - ok for proof of concept
        $this->response("Event Deleted", 200); // 200 being the HTTP response code
    }

	function device_list_for_event_get() {
    
		//This method returns the list of devices in an event

        if(!$this->get('event_id'))
        {
        	$this->response(array('error' => 'event_id missing in device_list_for_event get request'), 400);
        }

		//Load the model and ask it for the clients for the event
		$this->load->model('Mesh_display_server_model');
		$eventDevices = $this->Mesh_display_server_model->get_clients_for_event($this->get('event_id'));
    	
        if($eventDevices)
        {
            $this->response($eventDevices, 200); // 200 being the HTTP response code
        }

        else
        {
            $this->response(array('error' => 'Event could not be found'), 404);
        }
    }

    function event_client_text_post() {
    
		//This method sets the text for a particular client

	    if(!$this->post('client_id'))
        {
        	$this->response(array('error' => 'client_id missing in event_client_text post request'), 400);
        }

	    if(!$this->post('text'))
        {
        	$this->response(array('error' => 'text missing in event_client_text post request'), 400);
        }

        if(!$this->post('event_id'))
        {
        	$this->response(array('error' => 'event_id missing in event_client_text post request'), 400);
        }

	
		//Load the model and tell it to set the text for this client - no return value yet checking in this prrof
		//of concept
		$this->load->model('Mesh_display_server_model');
		$this->Mesh_display_server_model->update_client_text($this->post('event_id'), $this->post('client_id'), $this->post('text'));
		
		//Need to add error checeks here - ok for proof of concept
        $this->response("Added text for client", 200); // 200 being the HTTP response code
    }

    function event_client_post() {
    
		//This method add a client to an event

	    if(!$this->post('client_id'))
        {
        	$this->response(array('error' => 'client_id missing in event_client_post post request'), 400);
        }

	    if(!$this->post('event_id'))
        {
        	$this->response(array('error' => 'event_id missing in event_client_post post request'), 400);
        }
	
		//Load the model and tell it to add the client to the event - no return value yet checking in this prrof
		//of concept
		$this->load->model('Mesh_display_server_model');
		$this->Mesh_display_server_model->add_client_to_event($this->post('event_id'), $this->post('client_id'));
		
		//Need to add error checeks here - ok for proof of concept
        $this->response("Added client to event", 200); // 200 being the HTTP response code
    }

    function event_client_delete() {
    
		//This method removes a cleint from an event

	    if(!$this->delete('client_id'))
        {
        	$this->response(array('error' => 'client_id missing in client delete request'), 400);
        }
	
		//Load the model and ask it to delete the client
		$this->load->model('Mesh_display_server_model');
		$this->Mesh_display_server_model->delete_client_from_event($this->delete('client_id'));
        
		//Need to add error checeks here - ok for proof of concept
        $this->response("Client Deleted", 200); // 200 being the HTTP response code
    }

	function text_for_client_get() {
    
		//This method returns the text for a given client

        if(!$this->get('client_id'))
        {
        	$this->response(array('error' => 'client_id missing in text_for_client_get request'), 400);
        }

		//Load the model and ask it for the text for this client
		$this->load->model('Mesh_display_server_model');
		$clientText = $this->Mesh_display_server_model->get_text_for_client($this->get('client_id'));
    	
        if($clientText)
        {
            $this->response($clientText, 200); // 200 being the HTTP response code
        }

        else
        {
            $this->response(array('error' => 'Text could not be found for this client'), 404);
        }
    }

}