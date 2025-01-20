<?php
//gen 25/2/2024 22:21:29 dst
class alm_tblcierrecaja_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selcierrecaja($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selcierrecaja',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_viscierrecaja' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addcierrecaja($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addcierrecaja',$f3)) {
$Tipo = 'C';
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$montoinicio = is_null($f3->get('POST.pmontoinicio')) ? 'T' : $f3->get('POST.pmontoinicio');
$montofinal = is_null($f3->get('POST.pmontofinal')) ? 'T' : $f3->get('POST.pmontofinal');
$idusuariocierre = is_null($f3->get('POST.pidusuariocierre')) ? 'T' : $f3->get('POST.pidusuariocierre');
$idestadocierrecaja = is_null($f3->get('POST.pidestadocierrecaja')) ? 'T' : $f3->get('POST.pidestadocierrecaja');
$fechainicio = is_null($f3->get('POST.pfechainicio')) ? 'T' : $f3->get('POST.pfechainicio');
$fechafinal = is_null($f3->get('POST.pfechafinal')) ? 'T' : $f3->get('POST.pfechafinal');
$sql = "CALL alm_pagcierrecaja('" . $Tipo . "','". $idcierrecaja . "','". $idoficina . "','". $idusuario . "','". $montoinicio . "','". $montofinal . "','". $idusuariocierre . "','". $idestadocierrecaja . "','". $fechainicio . "','". $fechafinal. "'); "; 
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

public function getcierrecaja($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getcierrecaja',$f3)) {
$Tipo = 'R';
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$montoinicio = is_null($f3->get('POST.pmontoinicio')) ? 'T' : $f3->get('POST.pmontoinicio');
$montofinal = is_null($f3->get('POST.pmontofinal')) ? 'T' : $f3->get('POST.pmontofinal');
$idusuariocierre = is_null($f3->get('POST.pidusuariocierre')) ? 'T' : $f3->get('POST.pidusuariocierre');
$idestadocierrecaja = is_null($f3->get('POST.pidestadocierrecaja')) ? 'T' : $f3->get('POST.pidestadocierrecaja');
$fechainicio = is_null($f3->get('POST.pfechainicio')) ? 'T' : $f3->get('POST.pfechainicio');
$fechafinal = is_null($f3->get('POST.pfechafinal')) ? 'T' : $f3->get('POST.pfechafinal');
$sql = "CALL alm_pagcierrecaja('" . $Tipo . "','". $idcierrecaja . "','". $idoficina . "','". $idusuario . "','". $montoinicio . "','". $montofinal . "','". $idusuariocierre . "','". $idestadocierrecaja . "','". $fechainicio . "','". $fechafinal. "'); "; 
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

public function updcierrecaja($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updcierrecaja',$f3)) {
$Tipo = 'U';
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$montoinicio = is_null($f3->get('POST.pmontoinicio')) ? 'T' : $f3->get('POST.pmontoinicio');
$montofinal = is_null($f3->get('POST.pmontofinal')) ? 'T' : $f3->get('POST.pmontofinal');
$idusuariocierre = is_null($f3->get('POST.pidusuariocierre')) ? 'T' : $f3->get('POST.pidusuariocierre');
$idestadocierrecaja = is_null($f3->get('POST.pidestadocierrecaja')) ? 'T' : $f3->get('POST.pidestadocierrecaja');
$fechainicio = is_null($f3->get('POST.pfechainicio')) ? 'T' : $f3->get('POST.pfechainicio');
$fechafinal = is_null($f3->get('POST.pfechafinal')) ? 'T' : $f3->get('POST.pfechafinal');
$sql = "CALL alm_pagcierrecaja('" . $Tipo . "','". $idcierrecaja . "','". $idoficina . "','". $idusuario . "','". $montoinicio . "','". $montofinal . "','". $idusuariocierre . "','". $idestadocierrecaja . "','". $fechainicio . "','". $fechafinal. "'); "; 
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

public function papcierrecaja($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papcierrecaja',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$montoinicio = is_null($f3->get('POST.pmontoinicio')) ? 'T' : $f3->get('POST.pmontoinicio');
$montofinal = is_null($f3->get('POST.pmontofinal')) ? 'T' : $f3->get('POST.pmontofinal');
$idusuariocierre = is_null($f3->get('POST.pidusuariocierre')) ? 'T' : $f3->get('POST.pidusuariocierre');
$idestadocierrecaja = is_null($f3->get('POST.pidestadocierrecaja')) ? 'T' : $f3->get('POST.pidestadocierrecaja');
$fechainicio = is_null($f3->get('POST.pfechainicio')) ? 'T' : $f3->get('POST.pfechainicio');
$fechafinal = is_null($f3->get('POST.pfechafinal')) ? 'T' : $f3->get('POST.pfechafinal');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idcierrecaja . "','". $idoficina . "','". $idusuario . "','". $montoinicio . "','". $montofinal . "','". $idusuariocierre . "','". $idestadocierrecaja . "','". $fechainicio . "','". $fechafinal. "'); "; 
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
