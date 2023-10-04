<?php
    use App\Core\Controller;
    class Home extends Controller{
        private $vegeModel;

        function __construct(){
            $this->vegeModel = $this->model("VegetablesModel");
        }
        
        function Index(){
            // $result = $this->vegeModel->all();
            // if ($result != false) $data["vege"] = $result;
            
            // $this->view("products/index", $data);
            $this->view("home/index", []);
        }
    }
?>