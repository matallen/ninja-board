package com.redhat.sso.ninja.utils;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

public class ResponseUtils{

  public static ResponseBuilder newResponse(int status){
    return Response.status(status)
     .header("Access-Control-Allow-Origin",  "*")
     .header("Content-Type","application/json")
     .header("Cache-Control", "no-store, must-revalidate, no-cache, max-age=0")
     .header("Pragma", "no-cache")
     .header("X-Content-Type-Options", "nosniff");
  }
}
