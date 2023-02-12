package main

import (
	"bytes"
	"io"
	"log"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestMain(t *testing.T) {
	log.Println("nothing to test")
}

func TestKlaeffIndexHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	w := httptest.NewRecorder()
	handleKlaeffIndexRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	html, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(html, indexFile) {
		log.Fatal("html data not equal")
	}

	if res.Header.Get("Content-Type") != "text/html; charset=utf-8" {
		t.Errorf("expected content type 'text/html; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffVersionHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/version", nil)
	w := httptest.NewRecorder()
	handleKlaeffVersionRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	data, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}
	if string(data) != "{\"version\": \""+Version+"\"}" {
		t.Errorf("expected '{\"version\": \""+Version+"\"}' got '%v'", string(data))
	}

	if res.Header.Get("Content-Type") != "application/json; charset=utf-8" {
		t.Errorf("expected content type 'application/json; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}
	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffLogoHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/logo", nil)
	w := httptest.NewRecorder()
	handleKlaeffLogoRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	img, err := io.ReadAll(res.Body)

	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(img, logoImage) {
		log.Fatal("image data not equal")
	}

	if res.Header.Get("Content-Type") != "image/png" {
		t.Errorf("expected content type 'image/png' got '%v'", res.Header.Get("Content-Type"))
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffImpressumHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/impressum", nil)
	w := httptest.NewRecorder()
	handleKlaeffImpressumRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	img, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(img, impressumImage) {
		log.Fatal("image data not equal")
	}

	if res.Header.Get("Content-Type") != "image/png" {
		t.Errorf("expected content type 'image/png' got '%v'", res.Header.Get("Content-Type"))
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}
