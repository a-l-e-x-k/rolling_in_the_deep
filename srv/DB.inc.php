<?php

class DB
{
    public static $instance = null;

    public static function getInstance()
    {
        if (!self::$instance)
            self::$instance = new DB(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        return self::$instance;
    }

    private $conn;

    public $queryCount = 0;
    public $queryStats = array();
    public $queriesTime = 0;

    public function DB($host, $user, $pass, $dbname, $codepage = "UTF-8")
    {
        $this->conn = mysqli_connect($host, $user, $pass) or die();

        mysqli_query($this->conn, "SET NAMES '$codepage'");
        mysqli_select_db($this->conn, $dbname) or die("Can't select db");
    }

    public function __destruct()
    {
        if (is_resource($this->conn)) mysqli_close($this->conn);
    }

    public function query($query)
    {
        $this->queryCount++;
        $this->queryStats[$query] = time() + microtime();
        if ($result = mysqli_query($this->conn, $query)) {
            $this->queryStats[$query] = time() + microtime() - $this->queryStats[$query];
            $this->queriesTime += $this->queryStats[$query];
            return $result;
        }
        echo mysqli_error($this->conn);
        //else die();
    }

    private function fetch($result)
    {
        $res = array();
        while ($data = mysqli_fetch_assoc($result))
        {
            array_push($res, $data);
        }
        return $res;
    }

    public function selectQuery($query)
    {
        return $this->fetch($this->query($query));
    }

    public function singleSelect($query)
    {
        return mysqli_fetch_assoc($this->query($query));
    }

    public function count($table, $where)
    {
        $query = "SELECT COUNT(*) as count FROM " . $table . " WHERE " . $where;
        //echo $query;
        $result = $this->query($query);
        //echo mysql_error();
        if ($result) {
            $data = mysqli_fetch_assoc($result);
            return $data['count'];
        }
        return 0;
    }

    public function delete($table, $where)
    {
        $query = "DELETE FROM " . $table . " WHERE " . $where;
        $this->query($query);

        return mysqli_affected_rows($this->conn);
    }

    public function insert($table, $data, $delayed = false)
    {
        $fields = "";
        $values = "";

        $first = true;
        foreach ($data as $field => $value)
        {
            if (!$first) {
                $fields .= ',';
                $values .= ',';
            }
            $first = false;
            $fields .= "`" . $field . "`";
            $values .= "'" . mysqli_escape_string($value) . "'";
        }

        $query = "INSERT " . ($delayed ? "/*! DELAYED */" : "") . " INTO " . $table . " (" . $fields . ") VALUES (" . $values . ")";
        $result = $this->query($query);
        //echo $query.mysql_error();
        return mysqli_insert_id($this->conn);
    }

    public function update($table, $data, $where)
    {
        $fields = "";

        $first = true;
        foreach ($data as $field => $value)
        {
            if (!$first) {
                $fields .= ',';
            }
            $first = false;
            $fields .= "`" . $field . "` = '" . mysqli_escape_string($value) . "'";

        }
        $query = "UPDATE " . $table . " SET " . $fields . " WHERE " . $where;
        $result = $this->query($query);
        //echo mysql_error();
        return mysqli_insert_id($this->conn);
    }
}

?>
