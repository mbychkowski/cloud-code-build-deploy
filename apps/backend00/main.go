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
    c.JSON(http.StatusOK, gin.H{"body": "hello, world. :/"})
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
