<?php
//gen 25/2/2024 22:22:13 dst
class seg_tblrolusuario_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selrolusuario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selrolusuario',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('seg_visrolusuario' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addrolusuario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addrolusuario',$f3)) {
$Tipo = 'C';
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$idrol = is_null($f3->get('POST.pidrol')) ? 'T' : $f3->get('POST.pidrol');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idestadorolusuario = is_null($f3->get('POST.pidestadorolusuario')) ? 'T' : $f3->get('POST.pidestadorolusuario');
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtiporolusuario = is_null($f3->get('POST.pidtiporolusuario')) ? 'T' : $f3->get('POST.pidtiporolusuario');
$idusuariocreacion = is_null($f3->get('POST.pidusuariocreacion')) ? 'T' : $f3->get('POST.pidusuariocreacion');
$fechabaja = is_null($f3->get('POST.pfechabaja')) ? 'T' : $f3->get('POST.pfechabaja');
$sql = "CALL seg_pagrolusuario('" . $Tipo . "','". $idrolusuario . "','". $idrol . "','". $idusuario . "','". $idestadorolusuario . "','". $idubicacion . "','". $idtiporolusuario . "','". $idusuariocreacion . "','". $fechabaja. "'); "; 
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

public function getrolusuario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getrolusuario',$f3)) {
$Tipo = 'R';
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$idrol = is_null($f3->get('POST.pidrol')) ? 'T' : $f3->get('POST.pidrol');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idestadorolusuario = is_null($f3->get('POST.pidestadorolusuario')) ? 'T' : $f3->get('POST.pidestadorolusuario');
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtiporolusuario = is_null($f3->get('POST.pidtiporolusuario')) ? 'T' : $f3->get('POST.pidtiporolusuario');
$idusuariocreacion = is_null($f3->get('POST.pidusuariocreacion')) ? 'T' : $f3->get('POST.pidusuariocreacion');
$fechabaja = is_null($f3->get('POST.pfechabaja')) ? 'T' : $f3->get('POST.pfechabaja');
$sql = "CALL seg_pagrolusuario('" . $Tipo . "','". $idrolusuario . "','". $idrol . "','". $idusuario . "','". $idestadorolusuario . "','". $idubicacion . "','". $idtiporolusuario . "','". $idusuariocreacion . "','". $fechabaja. "'); "; 
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

public function updrolusuario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updrolusuario',$f3)) {
$Tipo = 'U';
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$idrol = is_null($f3->get('POST.pidrol')) ? 'T' : $f3->get('POST.pidrol');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idestadorolusuario = is_null($f3->get('POST.pidestadorolusuario')) ? 'T' : $f3->get('POST.pidestadorolusuario');
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtiporolusuario = is_null($f3->get('POST.pidtiporolusuario')) ? 'T' : $f3->get('POST.pidtiporolusuario');
$idusuariocreacion = is_null($f3->get('POST.pidusuariocreacion')) ? 'T' : $f3->get('POST.pidusuariocreacion');
$fechabaja = is_null($f3->get('POST.pfechabaja')) ? 'T' : $f3->get('POST.pfechabaja');
$sql = "CALL seg_pagrolusuario('" . $Tipo . "','". $idrolusuario . "','". $idrol . "','". $idusuario . "','". $idestadorolusuario . "','". $idubicacion . "','". $idtiporolusuario . "','". $idusuariocreacion . "','". $fechabaja. "'); "; 
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

public function paprolusuario($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'paprolusuario',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idrolusuario = is_null($f3->get('POST.pidrolusuario')) ? 'T' : $f3->get('POST.pidrolusuario');
$idrol = is_null($f3->get('POST.pidrol')) ? 'T' : $f3->get('POST.pidrol');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idestadorolusuario = is_null($f3->get('POST.pidestadorolusuario')) ? 'T' : $f3->get('POST.pidestadorolusuario');
$idubicacion = is_null($f3->get('POST.pidubicacion')) ? 'T' : $f3->get('POST.pidubicacion');
$idtiporolusuario = is_null($f3->get('POST.pidtiporolusuario')) ? 'T' : $f3->get('POST.pidtiporolusuario');
$idusuariocreacion = is_null($f3->get('POST.pidusuariocreacion')) ? 'T' : $f3->get('POST.pidusuariocreacion');
$fechabaja = is_null($f3->get('POST.pfechabaja')) ? 'T' : $f3->get('POST.pfechabaja');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idrolusuario . "','". $idrol . "','". $idusuario . "','". $idestadorolusuario . "','". $idubicacion . "','". $idtiporolusuario . "','". $idusuariocreacion . "','". $fechabaja. "'); "; 
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
