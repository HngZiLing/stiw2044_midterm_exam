<?php
if(!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$sqlloadtutor = "SELECT * FROM mytutordb.tbl_tutors";
$result = $conn->query($sqlloadtutor);

if($result->num_rows > 0) {
    $tutor["tutor"] = array();
    while($row = $result->fetch_assoc()) {
        $tutorlist = array();
        $tutorlist['tutor_id'] = $row['tutor_id'];
        $tutorlist['tutor_email'] = $row['tutor_email'];
        $tutorlist['tutor_phone'] = $row['tutor_phone'];
        $tutorlist['tutor_name'] = $row['tutor_name'];
        $tutorlist['tutor_password'] = $row['tutor_password'];
        $tutorlist['tutor_description'] = $row['tutor_description'];
        $tutorlist['tutor_datereg'] = $row['tutor_datereg'];
        array_push($tutor["tutor"], $tutorlist);
    }
    $response = array('status' => 'success', 'data' => $tutor);
    sendJsonResponse($response);
} else {

    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>