<?php
//gen 25/2/2024 22:21:56 dst
class per_tblpersona_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selpersona($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selpersona',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('per_vispersona' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addpersona($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addpersona',$f3)) {
$Tipo = 'C';
$idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
$idtipopersona = is_null($f3->get('POST.pidtipopersona')) ? 'T' : $f3->get('POST.pidtipopersona');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$direccion = is_null($f3->get('POST.pdireccion')) ? 'T' : $f3->get('POST.pdireccion');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$celularcontacto = is_null($f3->get('POST.pcelularcontacto')) ? 'T' : $f3->get('POST.pcelularcontacto');
$fechanacimiento = is_null($f3->get('POST.pfechanacimiento')) ? 'T' : $f3->get('POST.pfechanacimiento');
$idtiposexo = is_null($f3->get('POST.pidtiposexo')) ? 'T' : $f3->get('POST.pidtiposexo');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$nrodocumento = is_null($f3->get('POST.pnrodocumento')) ? 'T' : $f3->get('POST.pnrodocumento');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nit = is_null($f3->get('POST.pnit')) ? 'T' : $f3->get('POST.pnit');
$sql = "CALL per_pagpersona('" . $Tipo . "','". $idpersona . "','". $idtipopersona . "','". $nombre . "','". $paterno . "','". $materno . "','". $direccion . "','". $celular . "','". $celularcontacto . "','". $fechanacimiento . "','". $idtiposexo . "','". $observaciones . "','". $nrodocumento . "','". $idtipodocumento . "','". $nit. "'); "; 
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

public function getpersona($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getpersona',$f3)) {
$Tipo = 'R';
$idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
$idtipopersona = is_null($f3->get('POST.pidtipopersona')) ? 'T' : $f3->get('POST.pidtipopersona');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$direccion = is_null($f3->get('POST.pdireccion')) ? 'T' : $f3->get('POST.pdireccion');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$celularcontacto = is_null($f3->get('POST.pcelularcontacto')) ? 'T' : $f3->get('POST.pcelularcontacto');
$fechanacimiento = is_null($f3->get('POST.pfechanacimiento')) ? 'T' : $f3->get('POST.pfechanacimiento');
$idtiposexo = is_null($f3->get('POST.pidtiposexo')) ? 'T' : $f3->get('POST.pidtiposexo');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$nrodocumento = is_null($f3->get('POST.pnrodocumento')) ? 'T' : $f3->get('POST.pnrodocumento');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nit = is_null($f3->get('POST.pnit')) ? 'T' : $f3->get('POST.pnit');
$sql = "CALL per_pagpersona('" . $Tipo . "','". $idpersona . "','". $idtipopersona . "','". $nombre . "','". $paterno . "','". $materno . "','". $direccion . "','". $celular . "','". $celularcontacto . "','". $fechanacimiento . "','". $idtiposexo . "','". $observaciones . "','". $nrodocumento . "','". $idtipodocumento . "','". $nit. "'); "; 
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

public function updpersona($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updpersona',$f3)) {
$Tipo = 'U';
$idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
$idtipopersona = is_null($f3->get('POST.pidtipopersona')) ? 'T' : $f3->get('POST.pidtipopersona');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$direccion = is_null($f3->get('POST.pdireccion')) ? 'T' : $f3->get('POST.pdireccion');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$celularcontacto = is_null($f3->get('POST.pcelularcontacto')) ? 'T' : $f3->get('POST.pcelularcontacto');
$fechanacimiento = is_null($f3->get('POST.pfechanacimiento')) ? 'T' : $f3->get('POST.pfechanacimiento');
$idtiposexo = is_null($f3->get('POST.pidtiposexo')) ? 'T' : $f3->get('POST.pidtiposexo');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$nrodocumento = is_null($f3->get('POST.pnrodocumento')) ? 'T' : $f3->get('POST.pnrodocumento');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nit = is_null($f3->get('POST.pnit')) ? 'T' : $f3->get('POST.pnit');
$sql = "CALL per_pagpersona('" . $Tipo . "','". $idpersona . "','". $idtipopersona . "','". $nombre . "','". $paterno . "','". $materno . "','". $direccion . "','". $celular . "','". $celularcontacto . "','". $fechanacimiento . "','". $idtiposexo . "','". $observaciones . "','". $nrodocumento . "','". $idtipodocumento . "','". $nit. "'); "; 
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

public function pappersona($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'pappersona',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idpersona = is_null($f3->get('POST.pidpersona')) ? 'T' : $f3->get('POST.pidpersona');
$idtipopersona = is_null($f3->get('POST.pidtipopersona')) ? 'T' : $f3->get('POST.pidtipopersona');
$nombre = is_null($f3->get('POST.pnombre')) ? 'T' : $f3->get('POST.pnombre');
$paterno = is_null($f3->get('POST.ppaterno')) ? 'T' : $f3->get('POST.ppaterno');
$materno = is_null($f3->get('POST.pmaterno')) ? 'T' : $f3->get('POST.pmaterno');
$direccion = is_null($f3->get('POST.pdireccion')) ? 'T' : $f3->get('POST.pdireccion');
$celular = is_null($f3->get('POST.pcelular')) ? 'T' : $f3->get('POST.pcelular');
$celularcontacto = is_null($f3->get('POST.pcelularcontacto')) ? 'T' : $f3->get('POST.pcelularcontacto');
$fechanacimiento = is_null($f3->get('POST.pfechanacimiento')) ? 'T' : $f3->get('POST.pfechanacimiento');
$idtiposexo = is_null($f3->get('POST.pidtiposexo')) ? 'T' : $f3->get('POST.pidtiposexo');
$observaciones = is_null($f3->get('POST.pobservaciones')) ? 'T' : $f3->get('POST.pobservaciones');
$nrodocumento = is_null($f3->get('POST.pnrodocumento')) ? 'T' : $f3->get('POST.pnrodocumento');
$idtipodocumento = is_null($f3->get('POST.pidtipodocumento')) ? 'T' : $f3->get('POST.pidtipodocumento');
$nit = is_null($f3->get('POST.pnit')) ? 'T' : $f3->get('POST.pnit');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idpersona . "','". $idtipopersona . "','". $nombre . "','". $paterno . "','". $materno . "','". $direccion . "','". $celular . "','". $celularcontacto . "','". $fechanacimiento . "','". $idtiposexo . "','". $observaciones . "','". $nrodocumento . "','". $idtipodocumento . "','". $nit. "'); "; 
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
