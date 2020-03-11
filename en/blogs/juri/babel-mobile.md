---
translations:
  ru: /ru/blogs/juri/beibl-mobail
keywords: babel mobile
description: Babel Mobile helps to overcome language barriers.
title: Babel Mobile
---
I have an idea how to use mobile phones to overcome language barriers between people.

The problem of misunderstanding between people that speak different languages has an increased significance in our globalization time, yet there is no acceptable solution to make multilingual verbal communications easier. However, given the recent technological achievements it seems possible to help people communicating in their native tongue. My idea is to implement a client-server architecture using a mobile phone as the client device, and a translation engine on the server side. When a subscriber has a need to communicate with the other person in a different language, then he/she makes a call to the special service number, selects the translation direction by using an IVR menu or dictating it, and starts speaking into the microphone. After finishing a sentence, the second person can hear the translation from the phone speaker, or the first person can try to tell the translation to the second person. Alternatively, the second person can hear the translation from own phone if the first person enters the phone number and lets the server make a call to the second person to deliver the translation directly to the phone of the second person. In the simplest case this can serve as a handy phrasebook, and gradually improving the translation quality will make it more and more useful.

There are many real-life situations when people need to understand each other immediately, such as a tourist visiting a foreign country, or business people having a meeting, or patients who require medical care in life-threatening emergency situations, and many other.

Over half of the planet's population own mobile phones already. Many people have difficulties with explaining own thoughts to other people. What the world needs now is better understanding between people, so my idea will help connect people of different cultures and protect their own unique cultures because they will communicate in their native tongue.

Strong AI is a hard task. However, the current state of art in speech recognition and machine translation provides satisfactory results. The key point of my idea is that I believe no mobile device will have enough power to perform the translation on the client side. The maximum that can be done is implementing an applet (for instance, using the Android SDK) that will extract phonetic features from continuous speech and send them to the server. In any case we will need a server farm where adding more servers will improve the translation quality. Also better results can be achieved after a short period of training from the subscriber's phone. So the initial step is to deploy available software on the distributed server environment and to allocate local service phone numbers in different countries connecting them to the server farm via VoIP.

I think the proper measurement in the case of success of my idea is the number of people it will help to. With good implementation and promotion the number could be quite high, measured in millions.
