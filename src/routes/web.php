<?php

use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/users', function () {
    // return User::all();
    $users = Cache::rememberForever('users', function () {
        return User::all();
    });
    return $users;
});

Route::get('/visits', function () {
    $visits = Redis::incr('visits');

    return $visits;
});

Route::get('videos/{id}', function ($id) {
    $downloads = Redis::get("videos.{$id}.downloads");

    return view('downloads', compact('downloads'));
});

Route::get('/videos/{id}/download', function ($id) {
    Redis::incr("videos.{$id}.downloads");

    return back();
});

