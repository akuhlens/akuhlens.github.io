.PHONY: serve drafts publish debug clean

serve:
	hugo serve

drafts:
	hugo serve -D

publish:
	hugo
	$(MAKE) -C publish

debug:
	env DEBUG=true $(MAKE) drafts

clean:
	find . -name "*\~" -delete
