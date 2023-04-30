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

	if res.Header.Get("Content-Type") != "text/html; charset=utf-8" {
		t.Errorf("expected content type 'text/html; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}

	html, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(html, indexFile) {
		log.Fatal("html data not equal")
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

	if res.Header.Get("Content-Type") != "application/json; charset=utf-8" {
		t.Errorf("expected content type 'application/json; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}

	data, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}
	if string(data) != "{\"version\": \""+version+"\"}" {
		t.Errorf("expected '{\"version\": \""+version+"\"}' got '%v'", string(data))
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

	if res.Header.Get("Content-Type") != "image/png" {
		t.Errorf("expected content type 'image/png' got '%v'", res.Header.Get("Content-Type"))
	}

	img, err := io.ReadAll(res.Body)

	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(img, logoImage) {
		log.Fatal("image data not equal")
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

	if res.Header.Get("Content-Type") != "image/png" {
		t.Errorf("expected content type 'image/png' got '%v'", res.Header.Get("Content-Type"))
	}

	img, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(img, impressumImage) {
		log.Fatal("image data not equal")
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffFaviconHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/favicon.ico", nil)
	w := httptest.NewRecorder()
	handleKlaeffFaviconRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	if res.Header.Get("Content-Type") != "image/x-icon" {
		t.Errorf("expected content type 'image/x-icon' got '%v'", res.Header.Get("Content-Type"))
	}

	img, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if !bytes.Equal(img, faviconImage) {
		log.Fatal("image data not equal")
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffHealthHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	w := httptest.NewRecorder()
	handleKlaeffHealthRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	if res.Header.Get("Content-Type") != "text/plain; charset=utf-8" {
		t.Errorf("expected content type 'text/plain; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}

	txt, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if string(txt) != "1" {
		log.Fatalf("data not 1 : %v", string(txt))
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}

func TestKlaeffReadyHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/ready", nil)
	w := httptest.NewRecorder()
	handleKlaeffReadyRequest(w, req)
	res := w.Result()
	defer res.Body.Close()

	if res.Header.Get("Content-Type") != "text/plain; charset=utf-8" {
		t.Errorf("expected content type 'text/plain; charset=utf-8' got '%v'", res.Header.Get("Content-Type"))
	}

	txt, err := io.ReadAll(res.Body)
	if err != nil {
		t.Errorf("expected error to be nil got '%v'", err)
	}

	if string(txt) != "1" {
		log.Fatalf("data not 1 : %v", string(txt))
	}

	if res.StatusCode != 200 {
		t.Errorf("expected status code '200' got '%v'", res.StatusCode)
	}
}
