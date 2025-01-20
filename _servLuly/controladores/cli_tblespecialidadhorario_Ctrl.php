<?php
//gen 28/11/2023 16:05:52 dst
class cli_tblespecialidadhorario_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selespecialidadhorario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selespecialidadhorario',$f3)) {
$pCampo0 = is_null($f3->get('POST.pCampo0')) ? 'T' : $f3->get('POST.pCampo0');
$pValor0 = is_null($f3->get('POST.pValor0')) ? '' : $f3->get('POST.pValor0');
$pCampo1 = is_null($f3->get('POST.pCampo1')) ? 'T' : $f3->get('POST.pCampo1');
$pValor1 = is_null($f3->get('POST.pValor1')) ? '' : $f3->get('POST.pValor1');
$pCampo2 = is_null($f3->get('POST.pCampo2')) ? 'T' : $f3->get('POST.pCampo2');
$pValor2 = is_null($f3->get('POST.pValor2')) ? '' : $f3->get('POST.pValor2');
$pCampo3 = is_null($f3->get('POST.pCampo3')) ? 'T' : $f3->get('POST.pCampo3');
$pValor3 = is_null($f3->get('POST.pValor3')) ? '' : $f3->get('POST.pValor3');
$pCampo4 = is_null($f3->get('POST.pCampo4')) ? 'T' : $f3->get('POST.pCampo4');
$pValor4 = is_null($f3->get('POST.pValor4')) ? '' : $f3->get('POST.pValor4');
$pCampo5 = is_null($f3->get('POST.pCampo5')) ? 'T' : $f3->get('POST.pCampo5');
$pValor5 = is_null($f3->get('POST.pValor5')) ? '' : $f3->get('POST.pValor5');
$pCampo6 = is_null($f3->get('POST.pCampo6')) ? 'T' : $f3->get('POST.pCampo6');
$pValor6 = is_null($f3->get('POST.pValor6')) ? '' : $f3->get('POST.pValor6');
$pCampo7 = is_null($f3->get('POST.pCampo7')) ? 'T' : $f3->get('POST.pCampo7');
$pValor7 = is_null($f3->get('POST.pValor7')) ? '' : $f3->get('POST.pValor7');
$oDav_Ctrol = new _Dav_Ctrol();
$Con = $oDav_Ctrol->fnDevuelveConsulta('cli_visespecialidadhorario' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
$sql = $Con;
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function addespecialidadhorario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addespecialidadhorario',$f3)) {
$Tipo = 'C';
$idespecialidadhorario = is_null($f3->get('POST.pidespecialidadhorario')) ? 'T' : $f3->get('POST.pidespecialidadhorario');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horarefrigerioinicio = is_null($f3->get('POST.phorarefrigerioinicio')) ? 'T' : $f3->get('POST.phorarefrigerioinicio');
$horarefrigeriofin = is_null($f3->get('POST.phorarefrigeriofin')) ? 'T' : $f3->get('POST.phorarefrigeriofin');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$estahabilitado = is_null($f3->get('POST.pestahabilitado')) ? 'T' : $f3->get('POST.pestahabilitado');
$sql = "CALL cli_pagespecialidadhorario('" . $Tipo . "','". $idespecialidadhorario . "','". $idespecialidad . "','". $horainicio . "','". $horarefrigerioinicio . "','". $horarefrigeriofin . "','". $horafin . "','". $diasemana . "','". $idusuario . "','". $estahabilitado. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function getespecialidadhorario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getespecialidadhorario',$f3)) {
$Tipo = 'R';
$idespecialidadhorario = is_null($f3->get('POST.pidespecialidadhorario')) ? 'T' : $f3->get('POST.pidespecialidadhorario');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horarefrigerioinicio = is_null($f3->get('POST.phorarefrigerioinicio')) ? 'T' : $f3->get('POST.phorarefrigerioinicio');
$horarefrigeriofin = is_null($f3->get('POST.phorarefrigeriofin')) ? 'T' : $f3->get('POST.phorarefrigeriofin');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$estahabilitado = is_null($f3->get('POST.pestahabilitado')) ? 'T' : $f3->get('POST.pestahabilitado');
$sql = "CALL cli_pagespecialidadhorario('" . $Tipo . "','". $idespecialidadhorario . "','". $idespecialidad . "','". $horainicio . "','". $horarefrigerioinicio . "','". $horarefrigeriofin . "','". $horafin . "','". $diasemana . "','". $idusuario . "','". $estahabilitado. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function updespecialidadhorario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updespecialidadhorario',$f3)) {
$Tipo = 'U';
$idespecialidadhorario = is_null($f3->get('POST.pidespecialidadhorario')) ? 'T' : $f3->get('POST.pidespecialidadhorario');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horarefrigerioinicio = is_null($f3->get('POST.phorarefrigerioinicio')) ? 'T' : $f3->get('POST.phorarefrigerioinicio');
$horarefrigeriofin = is_null($f3->get('POST.phorarefrigeriofin')) ? 'T' : $f3->get('POST.phorarefrigeriofin');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$estahabilitado = is_null($f3->get('POST.pestahabilitado')) ? 'T' : $f3->get('POST.pestahabilitado');
$sql = "CALL cli_pagespecialidadhorario('" . $Tipo . "','". $idespecialidadhorario . "','". $idespecialidad . "','". $horainicio . "','". $horarefrigerioinicio . "','". $horarefrigeriofin . "','". $horafin . "','". $diasemana . "','". $idusuario . "','". $estahabilitado. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function cli_papespecialidadhorario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papespecialidadhorario',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idespecialidadhorario = is_null($f3->get('POST.pidespecialidadhorario')) ? 'T' : $f3->get('POST.pidespecialidadhorario');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$horainicio = is_null($f3->get('POST.phorainicio')) ? 'T' : $f3->get('POST.phorainicio');
$horarefrigerioinicio = is_null($f3->get('POST.phorarefrigerioinicio')) ? 'T' : $f3->get('POST.phorarefrigerioinicio');
$horarefrigeriofin = is_null($f3->get('POST.phorarefrigeriofin')) ? 'T' : $f3->get('POST.phorarefrigeriofin');
$horafin = is_null($f3->get('POST.phorafin')) ? 'T' : $f3->get('POST.phorafin');
$diasemana = is_null($f3->get('POST.pdiasemana')) ? 'T' : $f3->get('POST.pdiasemana');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$estahabilitado = is_null($f3->get('POST.pestahabilitado')) ? 'T' : $f3->get('POST.pestahabilitado');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idespecialidadhorario . "','". $idespecialidad . "','". $horainicio . "','". $horarefrigerioinicio . "','". $horarefrigeriofin . "','". $horafin . "','". $diasemana . "','". $idusuario . "','". $estahabilitado. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}
}
