<?php

class M_Usuariologueado extends \DB\SQL\Mapper
{
  public function __construct()
  {
    parent::__construct(\Base::instance()->get('DB'), 'seg_tblusuariologueado');
  }
  // public function ValidaSession(string $idusuario, string $Clave):bool
  //public  function ValidaSession(string $idusuario, string $Clave)
  public function ValidaSession($idusuario = "", $Clave = "", $Procedimiento = "", $f3)
  {
    $this->load(["idusuario = $idusuario and idestadollave=1 and llave = '$Clave'"]);
    if ($this->loaded() > 0) {
      try {
        $sql = "CALL pcontrolsesionlog('C','sisesc','" . $idusuario . "','" . $Procedimiento . "'); ";
        $f3->get('DB')->exec($sql);
      } catch (PDOException $e) {
      }
      return true;
    } else
      return false;
  }
  // public function CambiaPassword(string $idusuario, string $Clave): bool
  //public function CambiaPassword(string $idusuario, string $Clave)
  public function CambiaPassword($idusuario = "", $Clave = "")
  {
    $this->load(["idusuario = $idusuario and idestadollave=1 and llave = '$Clave'"]);
    if ($this->loaded() > 0)
      return true;
    else
      return false;
  }
}
