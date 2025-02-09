<?php
if($_SERVER["REQUEST_METHOD"] == "POST") {

    // החלף את כתובת המייל כאן, למייל האמיתי שלך
    $to = "YOUR_EMAIL@DOMAIN.COM"; 

    $subject = "New Form Submission - Golden Ace Website";

    // נבנה את גוף המייל
    $body = "New submission details:\n\n";
    foreach($_POST as $key => $value) {
        $body .= ucfirst($key) . ": " . $value . "\n";
    }

    // כותרות
    $headers = "From: no-reply@goldenacepoker.com\r\n";
    $headers .= "Reply-To: no-reply@goldenacepoker.com\r\n";

    // שליחת המייל
    mail($to, $subject, $body, $headers);

    // הפניה לעמוד תודה
    header("Location: ../thank-you.html");
    exit;

} else {
    // אם זה לא POST, מפנה לעמוד הבית
    header("Location: ../index.html");
    exit;
}
