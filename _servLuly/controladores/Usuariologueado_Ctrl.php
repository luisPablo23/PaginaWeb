<?php
//gen 11/11/2020 18:15:02 dst
class Usuariologueado_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selUsuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selUsuariologueado',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('visusuariologueado' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
$sql = $Con;
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = 'Lista de Usuariologueados';
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
$msg = 'Usuariologueado seleccionadas';
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
 $msg = 'llave no valida';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function addUsuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addUsuariologueado',$f3)) {
$Tipo = 'C';
$idusuariologueado = is_null($f3->get('POST.pidusuariologueado')) ? 'T' : $f3->get('POST.pidusuariologueado');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$llave = is_null($f3->get('POST.pllave')) ? 'T' : $f3->get('POST.pllave');
$idestadollave = is_null($f3->get('POST.pidestadollave')) ? 'T' : $f3->get('POST.pidestadollave');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$direccionip = is_null($f3->get('POST.pdireccionip')) ? 'T' : $f3->get('POST.pdireccionip');
$direccionhost = is_null($f3->get('POST.pdireccionhost')) ? 'T' : $f3->get('POST.pdireccionhost');
$direcciondest = is_null($f3->get('POST.pdirecciondest')) ? 'T' : $f3->get('POST.pdirecciondest');
$sql = "CALL pcruUsuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = 'add Usuariologueado';
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
$msg = 'Usuariologueado registrada';
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
 $msg = 'llave no valida';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function getUsuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getUsuariologueado',$f3)) {
$Tipo = 'R';
$idusuariologueado = is_null($f3->get('POST.pidusuariologueado')) ? 'T' : $f3->get('POST.pidusuariologueado');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$llave = is_null($f3->get('POST.pllave')) ? 'T' : $f3->get('POST.pllave');
$idestadollave = is_null($f3->get('POST.pidestadollave')) ? 'T' : $f3->get('POST.pidestadollave');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$direccionip = is_null($f3->get('POST.pdireccionip')) ? 'T' : $f3->get('POST.pdireccionip');
$direccionhost = is_null($f3->get('POST.pdireccionhost')) ? 'T' : $f3->get('POST.pdireccionhost');
$direcciondest = is_null($f3->get('POST.pdirecciondest')) ? 'T' : $f3->get('POST.pdirecciondest');
$sql = "CALL pcruUsuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = 'getUsuariologueado';
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
$msg = 'Usuariologueado encontrada';
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
 $msg = 'llave no valida';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function updUsuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updUsuariologueado',$f3)) {
$Tipo = 'U';
$idusuariologueado = is_null($f3->get('POST.pidusuariologueado')) ? 'T' : $f3->get('POST.pidusuariologueado');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$llave = is_null($f3->get('POST.pllave')) ? 'T' : $f3->get('POST.pllave');
$idestadollave = is_null($f3->get('POST.pidestadollave')) ? 'T' : $f3->get('POST.pidestadollave');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$direccionip = is_null($f3->get('POST.pdireccionip')) ? 'T' : $f3->get('POST.pdireccionip');
$direccionhost = is_null($f3->get('POST.pdireccionhost')) ? 'T' : $f3->get('POST.pdireccionhost');
$direcciondest = is_null($f3->get('POST.pdirecciondest')) ? 'T' : $f3->get('POST.pdirecciondest');
$sql = "CALL pcruUsuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = 'update Usuariologueado';
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
$msg = 'Usuariologueado encontrada';
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
 $msg = 'llave no valida';
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
