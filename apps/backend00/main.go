// Copyright 2023 Google LLC All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"net/http"
	"os"

  "github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"

	"backend00/handlers"
)

func main() {
  r := gin.Default()
	r.Use(cors.Default())

	version := os.Getenv("ENV")
	if (version == "") {
		version = "latest"
	}

	r.GET("/", func(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{"body": "hello, world. [ - 👾 - ]"})
  })

	r.GET("/albums", album.GetAlbums)

	r.GET("/version", func(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{"version": version})
  })

	r.GET("/healthz", func(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{"health": "ok"})
  })

  r.Run()
}
