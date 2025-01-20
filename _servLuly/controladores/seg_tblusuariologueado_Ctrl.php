<?php
//gen 25/2/2024 22:22:15 dst
class seg_tblusuariologueado_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selusuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selusuariologueado',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('seg_visusuariologueado' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addusuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addusuariologueado',$f3)) {
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
$idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
$sql = "CALL seg_pagusuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest . "','". $idsucursal. "'); "; 
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

public function getusuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getusuariologueado',$f3)) {
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
$idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
$sql = "CALL seg_pagusuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest . "','". $idsucursal. "'); "; 
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

public function updusuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updusuariologueado',$f3)) {
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
$idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
$sql = "CALL seg_pagusuariologueado('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest . "','". $idsucursal. "'); "; 
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

public function papusuariologueado($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papusuariologueado',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idusuariologueado = is_null($f3->get('POST.pidusuariologueado')) ? 'T' : $f3->get('POST.pidusuariologueado');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$llave = is_null($f3->get('POST.pllave')) ? 'T' : $f3->get('POST.pllave');
$idestadollave = is_null($f3->get('POST.pidestadollave')) ? 'T' : $f3->get('POST.pidestadollave');
$fecha = is_null($f3->get('POST.pfecha')) ? 'T' : $f3->get('POST.pfecha');
$direccionip = is_null($f3->get('POST.pdireccionip')) ? 'T' : $f3->get('POST.pdireccionip');
$direccionhost = is_null($f3->get('POST.pdireccionhost')) ? 'T' : $f3->get('POST.pdireccionhost');
$direcciondest = is_null($f3->get('POST.pdirecciondest')) ? 'T' : $f3->get('POST.pdirecciondest');
$idsucursal = is_null($f3->get('POST.pidsucursal')) ? 'T' : $f3->get('POST.pidsucursal');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idusuariologueado . "','". $idusuario . "','". $idrolusuario . "','". $llave . "','". $idestadollave . "','". $fecha . "','". $direccionip . "','". $direccionhost . "','". $direcciondest . "','". $idsucursal. "'); "; 
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
