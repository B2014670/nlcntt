<?php
    use App\Core\Controller;

    class Accounts extends Controller{
        private $userModel;

        function __construct(){
            $this->userModel = $this->model("UserModel");
        }

        function Index(){
            $this->view("auth/login", []);
        }

        function signin(){
            $result = $this->userModel->adminAuthenticate($_POST);
            if($result[0]===true){
                $_SESSION["admin"] = $result[1];
                header("Location: ".DOCUMENT_ROOT."/admin");
            }
            else {                
                // print_r($result);
                $this->view("auth/login", []);
                echo '<script>alert("Email hoặc mật khẩu không đúng! Hãy đăng nhập lại!")</script>';
            }
        }

        function logout(){
            session_destroy();
            header("Location: ".DOCUMENT_ROOT."/admin/accounts");
        }
    }
?>