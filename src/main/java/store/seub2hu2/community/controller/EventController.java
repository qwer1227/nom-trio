package store.seub2hu2.community.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/community/event")
public class EventController {

    @GetMapping("/main")
    public String Community() {
        return "community/event/main";
    }

    @GetMapping("/form")
    public String list() {
        return "community/event/form";
    }

    @GetMapping("/detail")
    public String detail() {
        return "community/event/detail";
    }

}
